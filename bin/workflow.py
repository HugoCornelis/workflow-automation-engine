#!/usr/bin/env python3
"""workflow.py -- a Python reimplementation of the Perl workflow engine.

It reads the SAME configuration files as the Perl engine
(``workflow-project.pl``, ``<project>-configuration-data/{workflow_filenames,
roles,targets,project_settings,node_configuration}.yml``) and runs command files
written in **Python**.  It exposes the same Python API to those command files
(``global_roles``, ``global_targets``, ``project_settings``,
``global_technical_project_configuration``, ``global_execution_context``,
``execute_command``, ``execute_command_array``, ``print_to_stdout`` /
``print_to_stderr`` ...), so existing ``.py`` command files run unchanged.

Supported, compatibly with the Perl engine:
  * configuration files and the field-project / technical-project structure;
  * roles (localuser, tmux ``send-keys``, ssh, docker ``exec``) and the
    ``execute_command_array;
  * options ``--interactions`` (schedule and print per role, no execution),
    ``--dry-run`` (no execution), ``--help`` (per-command help) and ``--list``.

Run it from a configuration directory (one that contains ``workflow-project.pl``),
e.g.  ``python3 bin/workflow.py <target> <operation> [args...] [--interactions]``.
"""

import os
import re
import sys
import shlex
import runpy  # noqa: F401  (kept for parity; command files are exec'd below)
import subprocess

try:
    import yaml
except ImportError:
    sys.stderr.write("workflow.py: PyYAML is required (pip install pyyaml)\n")
    sys.exit(2)


# --------------------------------------------------------------------------
# Engine state (mirrors the Perl $global_execution_context->{options})
# --------------------------------------------------------------------------
STATE = {
    "interactions": False,
    "dry_run": False,
    "help": False,
    "list": False,
    "current_function": None,   # name of the command function being dispatched
    "config_dir": None,
    "namespace": None,          # shared namespace holding the command functions + API
    "roles": {},
    "targets": {},
}


def _program_name():
    return os.path.basename(sys.argv[0]) or "workflow.py"


# --------------------------------------------------------------------------
# Configuration loading (compatible with the Perl engine's files)
# --------------------------------------------------------------------------
def _find_config_dir(start=None):
    """Walk up from the current directory looking for workflow-project.pl."""
    d = os.path.abspath(start or os.getcwd())
    while True:
        if os.path.isfile(os.path.join(d, "workflow-project.pl")):
            return d
        parent = os.path.dirname(d)
        if parent == d:
            return None
        d = parent


def _field_project_name(config_dir):
    """Read field_project_name from workflow-project.pl (parsed, not executed)."""
    try:
        with open(os.path.join(config_dir, "workflow-project.pl"), encoding="utf-8") as fh:
            text = fh.read()
    except OSError:
        return None
    m = re.search(r"field_project_name\s*=>\s*['\"]([^'\"]+)['\"]", text)
    return m.group(1) if m else None


def _load_yaml(path, key):
    try:
        with open(path, encoding="utf-8") as fh:
            data = yaml.safe_load(fh) or {}
    except OSError:
        return {} if key else {}
    if isinstance(data, dict) and key in data:
        return data[key]
    return data


def load_configuration():
    config_dir = _find_config_dir()
    if not config_dir:
        sys.stderr.write(
            f"{_program_name()}: *** Error: no workflow-project.pl found in this or any parent directory\n")
        sys.exit(2)
    name = _field_project_name(config_dir)
    if not name:
        sys.stderr.write(f"{_program_name()}: *** Error: could not read field_project_name from workflow-project.pl\n")
        sys.exit(2)

    data_dir = os.path.join(config_dir, f"{name}-configuration-data")
    roles = _load_yaml(os.path.join(data_dir, "roles.yml"), "roles") or {}
    targets = _load_yaml(os.path.join(data_dir, "targets.yml"), "targets") or {}
    project_settings = _load_yaml(os.path.join(data_dir, "project_settings.yml"), "project_settings") or {}
    node_configuration = _load_yaml(os.path.join(data_dir, "node_configuration.yml"), "node_configuration") or {}
    workflow_filenames = _load_yaml(os.path.join(data_dir, "workflow_filenames.yml"), "workflow_filenames") or []

    # every role carries its own name (the Perl engine relies on this too)
    for rname, rdef in list(roles.items()):
        if isinstance(rdef, dict):
            rdef.setdefault("name", rname)

    technical = {
        "roles": roles,
        "targets": targets,
        "project_settings": project_settings,
        "node_configuration": node_configuration,
        "workflow_filenames": workflow_filenames,
    }
    # The YAML config lives in <name>-configuration-data (loaded above); the command
    # data (e.g. c/ sources) lives in <name>-commands-data, which is what the field
    # project config calls sources_configuration_data_directory.
    commands_data_dir = os.path.join(config_dir, f"{name}-commands-data")
    field = {
        "field_project_name": name,
        "sources_configuration_directory": config_dir,
        "sources_configuration_data_directory": commands_data_dir,
    }
    gtpc = {
        "technical_project_configuration": technical,
        "field_project_configuration": field,
    }
    STATE["config_dir"] = config_dir
    STATE["roles"] = roles
    STATE["targets"] = targets
    STATE["project_name"] = name
    STATE["data_dir"] = data_dir
    STATE["commands_data_dir"] = commands_data_dir
    STATE["workflow_filenames"] = workflow_filenames
    return gtpc, name, config_dir, workflow_filenames


# --------------------------------------------------------------------------
# The Python API exposed to command files (mirrors the Perl engine's preamble)
# --------------------------------------------------------------------------
def _print_to_stdout(arg):
    # Bare write with NO trailing newline, exactly like the Perl print_to_stdout.
    sys.stdout.write("" if arg is None else str(arg))


def _print_to_stderr(arg):
    sys.stderr.write("" if arg is None else str(arg))


def _resolve_role(role):
    """Accept a role dict, a role name, or None (-> local)."""
    if role is None:
        return None
    if isinstance(role, dict):
        return role
    return STATE["roles"].get(role)


def _is_local(role):
    return role is None or str(role.get("localuser", "")).lower() in ("yes", "true", "1")


def _is_tmux(role):
    return bool(role) and str(role.get("name", "")).startswith("tmux_")


def _role_display(role):
    if _is_local(role):
        return "localuser@localhost"
    name = role.get("name", "?")
    if _is_tmux(role):
        return name
    user = role.get("ssh_user")
    return f"{user}@{name}" if user else name


def _wrap_for_role(role, command):
    """Build the local shell command that runs *command* under *role*."""
    if _is_local(role):
        return command
    rp = role.get("remote_policy")
    name = role.get("name", "")
    if name.startswith("tmux_") and rp:
        # tmux send-keys -t <session> '<command>' Enter   (fire-and-forget)
        return f"{rp}{shlex.quote(command)} Enter"
    if rp:
        # docker exec and similar literal prefixes
        return f"{rp} {shlex.quote(command)}"
    # plain ssh role
    server = role.get("ssh_server")
    if server:
        parts = ["sshpass", "-p", str(role["ssh_password"]), "ssh"] if role.get("ssh_password") else ["ssh"]
        if role.get("ssh_options"):
            parts += shlex.split(str(role["ssh_options"]))
        if role.get("ssh_port"):
            parts += ["-p", str(role["ssh_port"])]
        user = role.get("ssh_user")
        parts.append(f"{user}@{server}" if user else server)
        parts.append(command)
        return " ".join(shlex.quote(p) if " " in p else p for p in parts[:-1]) + " " + shlex.quote(command)
    return command


def _run_local(shell_command, capture):
    if capture:
        res = subprocess.run(shell_command, shell=True, text=True,
                             stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        sys.stdout.write(res.stdout or "")
        return res.returncode
    return subprocess.run(shell_command, shell=True).returncode


def execute_command_array(commands, options=None):
    """Run a list of shell commands under a role.  Honours --interactions / --dry-run.

    This is the function command files call as ``execute_command_array(cmds, {'role': role})``.
    """
    options = options or {}
    if isinstance(commands, str):
        commands = [commands]
    commands = [str(c) for c in commands]
    role = _resolve_role(options.get("role", options.get("remote")))

    # tmux roles are fire-and-forget: run the whole array as one ';'-joined line.
    tmux = _is_tmux(role)

    if STATE["interactions"]:
        sys.stdout.write(f"    ROLE: '{_role_display(role)}'\n\n")
        shown = [" ; ".join(commands)] if (tmux and len(commands) > 1) else commands
        for c in shown:
            sys.stdout.write(f"    '{c}'\n")
        return ""

    if STATE["dry_run"]:
        for c in ([" ; ".join(commands)] if (tmux and len(commands) > 1) else commands):
            sys.stdout.write(f"[dry-run] {_role_display(role)}: {c}\n")
        return ""

    # real execution
    rc = 0
    if tmux and len(commands) > 1:
        rc = _run_local(_wrap_for_role(role, " ; ".join(commands)), capture=False)
    else:
        for c in commands:
            wrapped = _wrap_for_role(role, c)
            # local + tmux dispatch are fire-and-forget-ish (stream); ssh/docker capture
            capture = not _is_local(role) and not tmux
            rc = _run_local(wrapped, capture=capture)
            if rc != 0:
                break
    return rc


def execute_command(command, options=None):
    return execute_command_array([command], options)


def _not_supported(name):
    def _stub(*args, **kwargs):
        sys.stderr.write(f"{_program_name()}: {name} is not implemented in workflow.py\n")
        return ""
    return _stub


def _completor_generic_expander(*args, **kwargs):
    return {}


def build_api_namespace(gtpc):
    """The shared namespace command files are exec'd into (one package, like Command::)."""
    roles = gtpc["technical_project_configuration"]["roles"]
    ns = {
        "__name__": "Command",
        # configuration, exactly as the Perl preamble exposes it
        "global_technical_project_configuration": gtpc,
        "global_roles": roles,
        "global_targets": gtpc["technical_project_configuration"]["targets"],
        "project_settings": gtpc["technical_project_configuration"]["project_settings"],
        "global_execution_context": {"options": STATE, "variables": {}},
        # API functions
        "execute_command": execute_command,
        "execute_command_array": execute_command_array,
        "execute_command_schedule": execute_command,
        "execute_command_schedule_array": execute_command_array,
        "execute_shell_script_remote": _not_supported("execute_shell_script_remote"),
        "print_to_stdout": _print_to_stdout,
        "print_to_stderr": _print_to_stderr,
        "_completor_generic_expander": _completor_generic_expander,
        # common stdlib modules command files use without importing (parity convenience)
    }
    return ns


# --------------------------------------------------------------------------
# Loading Python command files
# --------------------------------------------------------------------------
def load_command_files(ns, config_dir, workflow_filenames):
    loaded, skipped = [], []
    for fname in workflow_filenames:
        if not str(fname).endswith(".py"):
            skipped.append(fname)          # Perl command file -- not loaded (by design)
            continue
        path = os.path.join(config_dir, fname)
        if not os.path.isfile(path):
            sys.stderr.write(f"{_program_name()}: *** Warning: command file not found: {fname}\n")
            continue
        try:
            with open(path, encoding="utf-8") as fh:
                code = compile(fh.read(), path, "exec")
            exec(code, ns)                 # all files share one namespace (like Command::)
            loaded.append(fname)
        except Exception as exc:  # noqa: BLE001
            sys.stderr.write(f"{_program_name()}: *** Error: not a valid command file '{fname}': {exc}\n")
            sys.exit(2)
    return loaded, skipped


# --------------------------------------------------------------------------
# Command discovery / dispatch
# --------------------------------------------------------------------------
_SUFFIXES = ("_completor", "_completions", "_help")


def _command_functions(ns, targets):
    """Map 'target operation' -> function object, using targets.yml to split names."""
    tnames = sorted(targets.keys(), key=len, reverse=True)  # longest target prefix wins
    commands = {}
    for key, val in list(ns.items()):
        if key.startswith("_") or not callable(val) or key.endswith(_SUFFIXES):
            continue
        for t in tnames:
            if key == t or key.startswith(t + "_"):
                op = key[len(t) + 1:]
                if op:
                    commands[(t, op)] = key
                break
    return commands


def _usage(targets, commands):
    sys.stderr.write(f"usage: {_program_name()} <target> <operation> [args...] "
                     f"[--interactions] [--dry-run] [--help]\n\ntargets:\n")
    by_target = {}
    for (t, op) in sorted(commands):
        by_target.setdefault(t, []).append(op)
    for t in sorted(targets):
        desc = ""
        if isinstance(targets[t], dict):
            desc = targets[t].get("description", "")
        sys.stderr.write(f"  {t:<16} {desc}\n")
        for op in by_target.get(t, []):
            sys.stderr.write(f"      {op}\n")


def dispatch(ns, tokens):
    commands = _command_functions(ns, STATE["targets"])

    # built-in commands: 'builtin <operation> [args]'
    if tokens and tokens[0] == BUILTIN_TARGET:
        if len(tokens) < 2 or tokens[1] not in _BUILTINS:
            sys.stderr.write(f"{_program_name()}: *** Error: unknown builtin "
                             f"(known: {', '.join(sorted(_BUILTINS))})\n")
            return 2
        if STATE["help"]:
            sys.stdout.write(f"builtin {tokens[1]}: see the Perl engine's "
                             f"'builtin {tokens[1]} --help' for the full option set\n")
            return 0
        return _BUILTINS[tokens[1]](tokens[2:]) or 0

    if STATE["list"] or not tokens:
        _usage(STATE["targets"], commands)
        return 0 if STATE["list"] else 2

    if len(tokens) < 2:
        sys.stderr.write(f"{_program_name()}: *** Error: give a target and an operation "
                         f"(try --list)\n")
        return 2

    target, operation = tokens[0], tokens[1]
    argv = tokens[2:]
    fname = commands.get((target, operation))
    if not fname:
        # fall back to the literal function name, for robustness
        cand = f"{target}_{operation}"
        fname = cand if callable(ns.get(cand)) else None
    if not fname:
        sys.stderr.write(f"{_program_name()}: *** Error: unknown command '{target} {operation}' "
                         f"(try --list)\n")
        return 2

    if STATE["help"]:
        helper = ns.get(fname + "_help")
        if callable(helper):
            text = helper(f"{target} {operation}", argv)
            sys.stdout.write((text or "") + ("\n" if text and not str(text).endswith("\n") else ""))
        else:
            sys.stdout.write(f"no help page for '{target} {operation}'\n")
        return 0

    STATE["current_function"] = fname
    fn = ns[fname]

    if STATE["interactions"]:
        sys.stdout.write("---\n")
        sys.stdout.write(f"WORKFLOW: {fname} (use --help to see the help page)\n")

    try:
        result = fn(argv)
    except SystemExit:
        raise
    except Exception as exc:  # noqa: BLE001
        sys.stderr.write(f"\n{_program_name()}: *** Error: '{target} {operation}' raised: {exc}\n")
        return 2

    if STATE["interactions"]:
        sys.stdout.write("---\n")
        sys.stdout.write(f"END WORKFLOW: {fname}\n")

    return result if isinstance(result, int) else 0


# --------------------------------------------------------------------------
# Built-in commands:  builtin <project_start|configuration_install|target_add|role_add>
# --------------------------------------------------------------------------
BUILTIN_TARGET = "builtin"


def _bin_path_choice():
    return ".local/bin" if os.path.isdir(os.path.expanduser("~/.local/bin")) else "bin"


def _parse_builtin_options(argv, spec):
    """Parse --flag / --no-flag / --opt=val / --opt val, with unique-prefix matching.

    spec maps option-name -> 'bool' | 'str'.  Returns (positionals, options).
    """
    names = list(spec)
    opts, pos, i = {}, [], 0

    def resolve(tok):
        if tok in spec:
            return tok
        cands = [n for n in names if n.startswith(tok)]
        return cands[0] if len(cands) == 1 else None

    while i < len(argv):
        a = argv[i]
        if a.startswith("--") and a != "--":
            body, val = a[2:], None
            if "=" in body:
                body, val = body.split("=", 1)
            neg = body.startswith("no-")
            if neg:
                body = body[3:]
            name = resolve(body)
            if name is None:
                pos.append(a)          # unknown option -> leave as positional
            elif spec[name] == "bool":
                opts[name] = not neg
            else:
                if val is None:
                    i += 1
                    val = argv[i] if i < len(argv) else ""
                opts[name] = val
        else:
            pos.append(a)
        i += 1
    return pos, opts


def _dump_yaml(path, data):
    with open(path, "w", encoding="utf-8") as fh:
        yaml.safe_dump(data, fh, default_flow_style=False, sort_keys=False)


def _builtin_add_workflow_filename(data_dir, filename, kind, target):
    path = os.path.join(data_dir, "workflow_filenames.yml")
    doc = _load_yaml(path, None)
    if not isinstance(doc, dict):
        doc = {}
    names = doc.get("workflow_filenames") or []
    names.append(filename)
    doc["workflow_filenames"] = sorted(set(names))   # dedupe + sort, like the Perl engine
    _dump_yaml(path, doc)
    sys.stdout.write(f"{_program_name()}: registered the {kind} command file name {filename} for target {target}\n")


_PY_TEMPLATE = '''#!/usr/bin/python3

# Use the variable global_technical_project_configuration to access the configuration.
# Project settings are available from the dictionary project_settings.
# Roles are available as the variable global_roles.
# Targets are available as the variable global_targets.
# The mapping global_execution_context provides live access to the execution context.
# The functions print_to_stdout / print_to_stderr print to STDOUT / STDERR.


def {t}_python_command(argv):
    command = "echo command1"
    execute_command(command)
    command_array = [
        "echo command2",
        "echo command3",
    ]
    execute_command_array(command_array)


def {t}_python_command_completor(command, argv, analysis):
    return {{
        "1._first_completion": "explain the purpose here",
        "2._second_completion": "the numbers preserve the order",
    }}


def {t}_python_command_help(command, argv):
    return f"{{command}}: example python command for target {t}"
'''


def _require_config(builtin):
    if not STATE.get("config_dir"):
        sys.stderr.write(f"{_program_name()}: *** Error: '{builtin}' must run inside a project "
                         f"(no workflow-project.pl found)\n")
        sys.exit(2)


def builtin_role_add(argv):
    _require_config("builtin role_add")
    spec = {"localuser": "bool", "dockerfile": "str", "scp-options": "str", "ssh-options": "str",
            "ssh-password": "str", "ssh-port": "str", "ssh-server": "str", "ssh-user": "str",
            "tmux-session": "str"}
    pos, opts = _parse_builtin_options(argv, spec)
    if len(pos) < 2:
        sys.stderr.write(f"{_program_name()}: *** Error: usage: builtin role_add <name> <description> [options]\n")
        return 2
    name, description = pos[0], pos[1]
    data_dir = STATE["data_dir"]
    roles_file = os.path.join(data_dir, "roles.yml")
    doc = _load_yaml(roles_file, None)
    if not isinstance(doc, dict):
        doc = {}
    roles = doc.setdefault("roles", {})
    if name in roles:
        sys.stderr.write(f"{_program_name()}: *** Error: role {name} already exists\n")
        return 2

    remote_policy = None
    role = {"description": description, "name": name}
    if opts.get("dockerfile"):
        if not name.startswith("docker_"):
            sys.stderr.write(f"{_program_name()}: *** Error: Docker role names must start with 'docker_'.\n")
            return 2
        remote_policy = f"docker exec -it {name}_container bash -ic "
        role["dockerfile"] = opts["dockerfile"]
        role["remote_policy"] = remote_policy
    if opts.get("tmux-session"):
        if not name.startswith("tmux_"):
            sys.stderr.write(f"{_program_name()}: *** Error: tmux role names must start with 'tmux_'.\n")
            return 2
        remote_policy = f"tmux send-keys -t {opts['tmux-session']} "
        role["remote_policy"] = remote_policy
    if opts.get("localuser"):
        if remote_policy:
            sys.stderr.write(f"{_program_name()}: *** Error: a role with a remote_policy cannot be a localuser.\n")
            return 2
        role["localuser"] = "yes"
    for key, rkey in (("scp-options", "scp_options"), ("ssh-options", "ssh_options"),
                      ("ssh-password", "ssh_password"), ("ssh-port", "ssh_port"),
                      ("ssh-server", "ssh_server"), ("ssh-user", "ssh_user")):
        if opts.get(key):
            role[rkey] = opts[key]

    if STATE["interactions"] or STATE["dry_run"]:
        sys.stdout.write(yaml.safe_dump({"role": role}, default_flow_style=False, sort_keys=False))
        return 0
    if opts.get("dockerfile"):
        os.makedirs(os.path.join(data_dir, "dockerfiles"), exist_ok=True)
        _run_local(f"cp -a {shlex.quote(opts['dockerfile'])} {shlex.quote(os.path.join(data_dir, 'dockerfiles'))}", capture=False)
    roles[name] = role
    _dump_yaml(roles_file, doc)
    sys.stdout.write(f"{_program_name()}: added role {name} to {roles_file}\n")
    return 0


def builtin_target_add(argv):
    _require_config("builtin target_add")
    spec = {"install-commands-python": "bool", "install-commands-perl": "bool",
            "install-commands-pl": "bool", "install-commands-sh": "bool"}
    pos, opts = _parse_builtin_options(argv, spec)
    if len(pos) < 2:
        sys.stderr.write(f"{_program_name()}: *** Error: usage: builtin target_add <name> <description> [options]\n")
        return 2
    target, description = pos[0], pos[1]
    if STATE["interactions"] or STATE["dry_run"]:
        sys.stdout.write(f"[would add target '{target}': {description}]\n")
        return 0
    data_dir = STATE["data_dir"]
    name = STATE["project_name"]
    targets_file = os.path.join(data_dir, "targets.yml")
    doc = _load_yaml(targets_file, None)
    if not isinstance(doc, dict):
        doc = {}
    targets = doc.setdefault("targets", {})
    targets.setdefault(target, {})["description"] = description   # overwrite description, like Perl
    _dump_yaml(targets_file, doc)
    sys.stdout.write(f"{_program_name()}: added target {target} to {targets_file}\n")

    # --install-commands-py is accepted as a prefix of --install-commands-python.
    if opts.get("install-commands-python"):
        fname = f"{name}-commands-{target}.py"
        _builtin_add_workflow_filename(data_dir, fname, "python", target)
        path = os.path.join(STATE["config_dir"], fname)
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(_PY_TEMPLATE.format(t=target))
        os.chmod(path, 0o700)
        sys.stdout.write(f"{_program_name()}: created the python command file {fname} for target {target}\n")
    if opts.get("install-commands-perl") or opts.get("install-commands-pl"):
        fname = f"{name}-commands-{target}"
        _builtin_add_workflow_filename(data_dir, fname, "perl", target)
        sys.stdout.write(f"{_program_name()}: note: perl command files are not generated by workflow.py "
                         f"(registered {fname} only)\n")
    if opts.get("install-commands-sh"):
        sys.stdout.write(f"{_program_name()}: note: shell command files are not generated by workflow.py\n")
    return 0


def _bashrc_append(marker, block):
    """Idempotent append: add *block* to ~/.bashrc only if *marker* is not present."""
    bashrc = os.path.expanduser("~/.bashrc")
    return (f"grep -qF -- {shlex.quote(marker)} {shlex.quote(bashrc)} 2>/dev/null "
            f"|| printf '%s' {shlex.quote(block)} >> {shlex.quote(bashrc)}")


def builtin_configuration_install(argv):
    _require_config("builtin configuration_install")
    spec = {"aliasses": "bool", "bash-completion": "bool", "commands": "bool", "engine": "bool",
            "force": "bool", "git": "bool", "grc-configuration": "bool", "path-in-bashrc": "bool",
            "report": "bool", "bash": "bool"}
    _, opts = _parse_builtin_options(argv, spec)
    if opts.get("bash"):                      # '--bash' seen in practice as bash-completion
        opts.setdefault("bash-completion", True)

    home = os.path.expanduser("~")
    binp = _bin_path_choice()
    bindir = f"{home}/{binp}"
    cfgdir = os.path.abspath(STATE["config_dir"])
    name = STATE["project_name"]

    cmds = [f"mkdir --parents {shlex.quote(bindir)}"]
    # 1. engine + configuration symbolic links (engine on by default)
    if opts.get("engine", True):
        cmds.append(f"ln -sf {shlex.quote('/usr/local/bin/workflow')} "
                    f"{shlex.quote(os.path.join(bindir, name + '-workflow'))}")
    cmds.append(f"ln -sf {shlex.quote(os.path.join(cfgdir, name + '-configuration'))} "
                f"{shlex.quote(os.path.join(bindir, name + '-configuration'))}")
    # 2. command-file symbolic links (only with --commands)
    if opts.get("commands"):
        for f in STATE.get("workflow_filenames", []):
            cmds.append(f"ln -sf {shlex.quote(os.path.join(cfgdir, f))} "
                        f"{shlex.quote(os.path.join(bindir, f))}")
    # 3. PATH in .bashrc (only with --path-in-bashrc)
    if opts.get("path-in-bashrc"):
        marker = f'export PATH="$HOME/{binp}:$PATH"'
        cmds.append(_bashrc_append(marker, f"# necessary for {name}-workflow\n\n{marker}\n\n"))
    # 4. grc aliases (on by default, off with --no-aliasses)
    if opts.get("aliasses", True):
        block = (f"# {name}-workflow\n\n"
                 f'alias {name}-workflow="grc {name}-workflow"\n'
                 f'alias {name}-configuration="grc {name}-configuration"\n')
        cmds.append(_bashrc_append(f"alias {name}-workflow=", block))
    # 5. bash completion sourcing (on by default)
    if opts.get("bash-completion", True):
        bc = os.path.join(cfgdir, f"{name}-bash-completion.sh")
        if os.path.exists(bc):
            cmds.append(_bashrc_append(f". {bc}", f". {bc}\n"))
    # 6. grc configuration (on by default; best-effort, needs sudo -> never fatal)
    if opts.get("grc-configuration", True):
        for part in ("configuration", "workflow"):
            src = os.path.join(cfgdir, f"conf.{name}-{part}")
            cmds.append(f"[ -e {shlex.quote(src)} ] && sudo ln -sf {shlex.quote(src)} "
                        f"/usr/share/grc/conf.{name}-{part} || true")
    # 7. git repository (only with --git)
    if opts.get("git"):
        cmds += [
            "git init -b master",
            "echo >.gitignore '*~'",
            f"echo >>.gitignore '{name}-commands-data/cache'",
            f"echo >>.gitignore '{name}-configuration-data/cache'",
            "git add --all",
            "git commit --quiet --message " + shlex.quote(
                f"Default workflow engine configuration for project {name}.") + " || true",
        ]

    execute_command_array(cmds, {})   # local role; honours --interactions / --dry-run

    if not (STATE["interactions"] or STATE["dry_run"]):
        sys.stdout.write("\nBash completion can be enabled using:\n\n")
        sys.stdout.write(f"  . ./{name}-bash-completion.sh\n\n")
        sys.stdout.write("Or add or modify a first target, for example 'source_code':\n\n")
        sys.stdout.write(f"  {name}-workflow builtin target_add source_code "
                         f"\"Operations on the source code, such as git checkout, build and installation.\" "
                         f"-- --install-commands-py\n\n")
    return 0


# ----- project_start: scaffold a new project (runs in an empty directory) -----
_PROJECT_PL = '''#!/usr/bin/perl -w

use strict;

use warnings;

my $configuration
    = {{
       field_project_name => '{name}',
      }};

return $configuration;
'''

_CONFIGURATION_PL = '''#!/usr/bin/perl -w

use strict;

use warnings;

require YAML::PP;

my $workflow_filenames = eval {{ YAML::PP::LoadFile('{name}-configuration-data/workflow_filenames.yml'); }};
my $node_configuration = eval {{ YAML::PP::LoadFile('{name}-configuration-data/node_configuration.yml'); }};
my $project_settings   = eval {{ YAML::PP::LoadFile('{name}-configuration-data/project_settings.yml'); }};
my $roles              = eval {{ YAML::PP::LoadFile('{name}-configuration-data/roles.yml'); }};
my $targets            = eval {{ YAML::PP::LoadFile('{name}-configuration-data/targets.yml'); }};

my $configuration = {{
                      %{{ ref $workflow_filenames eq 'HASH' ? $workflow_filenames : {{}}; }},
                      %{{ ref $node_configuration eq 'HASH' ? $node_configuration : {{}}; }},
                      %{{ ref $project_settings eq 'HASH' ? $project_settings : {{}}; }},
                      %{{ ref $roles eq 'HASH' ? $roles : {{}}; }},
                      %{{ ref $targets eq 'HASH' ? $targets : {{}}; }},
                     }};

return $configuration;
'''

_BASH_COMPLETION = '''# bash completion for {name}-workflow (generated by workflow.py builtin project_start)
_{func}_complete() {{
    local cur="${{COMP_WORDS[COMP_CWORD]}}"
    # a minimal completion: list the targets and operations via --list
    local words
    words=$({name}-workflow --list 2>/dev/null | awk '{{print $1}}' | grep -v '^$')
    COMPREPLY=( $(compgen -W "${{words}}" -- "${{cur}}") )
}}
complete -F _{func}_complete {name}-workflow
'''


def builtin_project_start(argv):
    spec = {"minimal": "bool", "perl": "bool", "python": "bool", "shell": "bool"}
    pos, opts = _parse_builtin_options(argv, spec)
    if STATE["interactions"] or STATE["dry_run"]:
        sys.stdout.write("[project_start does nothing under --interactions/--dry-run]\n")
        return 0
    if not pos:
        sys.stderr.write(f"{_program_name()}: *** Error: give a project name: builtin project_start <name>\n")
        return 2
    name = re.sub(r"(.*)-commands?$", r"\1", pos[0])
    if os.listdir("."):
        sys.stderr.write(f"{_program_name()}: *** Error: the current directory must be empty "
                         f"so the workflow configuration is isolated from other files.\n")
        return 2

    create_python = True
    if opts.get("minimal") or opts.get("perl") or opts.get("python") or opts.get("shell"):
        create_python = bool(opts.get("python"))

    sys.stdout.write(f"Using '{name}' for the name of your project.\n")
    data_dir = f"{name}-configuration-data"
    os.makedirs(data_dir, exist_ok=True)
    os.makedirs(f"{name}-commands-data", exist_ok=True)

    with open("workflow-project.pl", "w", encoding="utf-8") as fh:
        fh.write(_PROJECT_PL.format(name=name))
    with open(f"{name}-configuration", "w", encoding="utf-8") as fh:
        fh.write(_CONFIGURATION_PL.format(name=name))
    os.chmod(f"{name}-configuration", 0o755)

    command_files = []
    if create_python:
        cf = f"{name}-commands-examples.py"
        with open(cf, "w", encoding="utf-8") as fh:
            fh.write(_PY_TEMPLATE.format(t="examples"))
        os.chmod(cf, 0o700)
        command_files.append(cf)

    _dump_yaml(os.path.join(data_dir, "workflow_filenames.yml"), {"workflow_filenames": sorted(command_files)})
    _dump_yaml(os.path.join(data_dir, "roles.yml"), {"roles": {
        "laptop": {"description": "the local computer of the developer", "name": "laptop", "localuser": "yes"},
    }})
    _dump_yaml(os.path.join(data_dir, "targets.yml"), {"targets": {
        "examples": {"description": "example commands demonstrating the workflow engine"},
    }})
    _dump_yaml(os.path.join(data_dir, "project_settings.yml"), {"project_settings": {
        "any_key_here": {"description": "Project-specific settings go here."},
    }})
    _dump_yaml(os.path.join(data_dir, "node_configuration.yml"), {"node_configuration": {
        "0_concepts": {"description00": "Node / IP configuration goes here."},
    }})

    func = re.sub(r"[^A-Za-z0-9_]", "_", name)
    with open(f"{name}-bash-completion.sh", "w", encoding="utf-8") as fh:
        fh.write(_BASH_COMPLETION.format(name=name, func=func))
    with open("README.md", "w", encoding="utf-8") as fh:
        fh.write(f"# {name}\n\nWorkflow-engine configuration for project `{name}`, "
                 f"created by `workflow.py builtin project_start`.\n")

    sys.stdout.write(f"Created a configuration for project '{name}'\n")
    sys.stdout.write("---\nInstall it on your system with:\n\n")
    sys.stdout.write(f"  workflow.py builtin configuration_install -- --commands --git\n\n")
    if create_python:
        sys.stdout.write("Then try, for example:\n\n")
        sys.stdout.write(f"  {name}-workflow examples python_command --interactions\n\n")
    return 0


_BUILTINS = {
    "project_start": builtin_project_start,
    "configuration_install": builtin_configuration_install,
    "target_add": builtin_target_add,
    "role_add": builtin_role_add,
}


# --------------------------------------------------------------------------
# Option parsing + main
# --------------------------------------------------------------------------
def parse_args(argv):
    """Split engine options from the command tokens.  '--' passes the rest through."""
    tokens, i, passthrough = [], 0, False
    while i < len(argv):
        a = argv[i]
        if passthrough:
            tokens.append(a)
        elif a == "--":
            passthrough = True
        elif a in ("--interactions", "--interactions-all"):
            STATE["interactions"] = True
        elif a == "--dry-run":
            STATE["dry_run"] = True
        elif a in ("--help", "-h"):
            STATE["help"] = True
        elif a == "--list":
            STATE["list"] = True
        elif a.startswith("--"):
            # unknown engine option: ignore (the Perl engine has many more); keep going
            sys.stderr.write(f"{_program_name()}: note: ignoring unsupported option {a}\n")
        else:
            tokens.append(a)
        i += 1
    return tokens


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    tokens = parse_args(argv)

    # 'builtin project_start' scaffolds a NEW project, so it runs before (and without)
    # loading a configuration -- there is no workflow-project.pl yet.
    if len(tokens) >= 2 and tokens[0] == BUILTIN_TARGET and tokens[1] == "project_start":
        return builtin_project_start(tokens[2:]) or 0

    gtpc, name, config_dir, workflow_filenames = load_configuration()
    ns = build_api_namespace(gtpc)
    STATE["namespace"] = ns
    load_command_files(ns, config_dir, workflow_filenames)
    return dispatch(ns, tokens)


if __name__ == "__main__":
    sys.exit(main() or 0)
