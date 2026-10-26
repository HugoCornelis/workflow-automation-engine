#!/usr/bin/python3

# use the variable global_technical_project_configuration to access the configuration
# roles are available as the variable global_roles
# targets are available as the variable global_targets


def features_background_testing(argv):
    execute_command("echo 'foreground command (1)'")
    execute_command("echo 'background command'", { "background": "for testing" } )
    execute_command("echo 'foreground command (2)'")


def features_background(argv):
    # command = "echo python_command1"
    # execute_command(command)
    # command_array = [
    #     "echo python_command2",
    #     "echo python_command3"
    # ]
    # execute_command_array(command_array)
    pass


    # Some options to command execution:
    #   allow_fail: allow execution of this command to fail.
    #   allow_fail_silent: allow execution of this command to fail and remain silent about it when it does.
    #   background: run the command in the background with 'setsid  >/dev/null 2>&1 ... &'
    #   dry_run: do not execute this command.
    #   role: a role that is defined in feature-testing-configuration.
    #   quiet: do not provide feedback to the terminal about this command.
    #   sudo: invoke the command prefixed with sudo.
    #   timeout: this command will fail after the given timeout.
    #   use_bash: use bash to invoke the command because it uses specific bash functions or features.
    #   with_stamp: create a .timestamp_<subname>_<suffix> file in the current directory,
    #               the hash value is either just '1' or a string that is used for the <suffix>.
    #
    # execute_shell_command(command, { 'role': '<name of a role that is defined in the global global_roles>', } )
    #
    # These options can given to any of the functions that execute commands.

def features_background_completions(command, argv):
    completions_hash = {
           "1._<your_completion_without_spaces_here>": "more_nested_dictionary_items_here",
           "2._<another_completion_here>": "the_numbers_preserve_the_order_for_this_example",
           "3._Don't_use_spaces_in_your_completions,_because_they_confuse_bash": "",
          }

    return completions_hash


def features_background_help(command, argv):
    return f"{command}: <synopsis> and an rst or md formatted help page"


# A feature for testing the engine's per-role command-array handling: it
# dispatches a multi-command array to the role named by the first argument
# (default laptop).  With a tmux role the engine concatenates the array into one
# ';'-joined line (fire-and-forget safety); other roles keep the commands
# separate.  Inspect the difference with --interactions.

def features_command_concatenation(argv):
    role_name = argv[0] if len(argv) > 0 else 'laptop'
    role = global_roles[role_name]
    command_array = [
        "echo one",
        "echo two",
        "echo three",
    ]
    execute_command_array(command_array, { "role": role })


def features_command_concatenation_completions(command, argv):
    return {
        "laptop": "a non-tmux (localuser) role -> separate lines",
        "ssh_cd": "a non-tmux ssh role -> separate lines",
        "tmux_cd": "a tmux role -> one concatenated line",
    }


def features_command_concatenation_help(command, argv):
    return f"{command}: run a three-command array on the given role (default laptop) to exercise the engine's per-role command-array handling; inspect with --interactions"
