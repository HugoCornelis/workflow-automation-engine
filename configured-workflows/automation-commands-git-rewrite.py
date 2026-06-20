#!/usr/bin/python3

# use the variable global_technical_project_configuration to access the configuration
# roles are available as the variable global_roles
# targets are available as the variable global_targets

technical_project_configuration = global_technical_project_configuration['technical_project_configuration']

def git_rewrite(argv):
    arguments = argv if len(argv) == 3 else [ '', '', '' ]
    commands = []
    if arguments[0] == '' or arguments[1] == '' or arguments[2] == '':
        commands = [
            'echo "This command requires the new and the old branch names as arguments"',
        ]
    else:
        base_branch = arguments[0]
        old_branch = arguments[1]
        new_branch = arguments[2]

        commands = [
            f"echo This has not been tested yet, run it with --dry-run to see the commented commands",
            f"echo Merge base is: \"$(git merge-base HEAD {base_branch})\"",
            f"git switch -c {new_branch} {old_branch} && git rebase --exec 'git commit --amend --no-edit --date=now' \"$(git merge-base HEAD {base_branch})\""
        ]

    execute_command_array(commands)


    # Some options to command execution:
    #   allow_fail: allow execution of this command to fail.
    #   allow_fail_silent: allow execution of this command to fail and remain silent about it when it does.
    #   background: run the command in the background with 'setsid  >/dev/null 2>&1 ... &'
    #   dry_run: do not execute this command.
    #   role: a role that is defined in automation-configuration.
    #   quiet: do not provide feedback to the terminal about this command.
    #   sudo: invoke the command prefixed with sudo.
    #   timeout: this command will fail after the given timeout.
    #   use_bash: use bash to invoke the command because it uses specific bash functions or features.
    #   with_stamp: create a .timestamp_<subname>_<suffix> file in the current directory,
    #               the hash value is either just '1' or a string that is used for the <suffix>.
    #
    # execute_shell_command($command, { 'role': '<name of a role that is defined in automation-configuration>, } )
    #
    # These options can given to any of the functions that execute commands.

def git_rewrite_completions(command, argv, status):

#     print_to_stderr(f"command: {command}\n  argv: {argv}")

    completions_hash = { }
    complete = True if len(argv) == 2 else False
    if complete:
        completions_hash = {
            "1._<base-branch>": "",
            "2._<old-branch>": "",
            "3._<new-branch>": "",
        }

    return completions_hash


def git_rewrite_help(command, argv):
    return f"""{command}: rewrite the commits in a branch and give them the current time for both author and commit date.

    ``ARGV[0]``   The base branch name, i.e. the branch where the old branch is based on.

    ``ARGV[1]``   The old branch name.

    ``ARGV[2]``   The new branch name.

"""

