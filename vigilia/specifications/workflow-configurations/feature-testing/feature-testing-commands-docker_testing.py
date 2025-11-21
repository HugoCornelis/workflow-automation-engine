#!/usr/bin/python3

technical_project_configuration = global_technical_project_configuration['technical_project_configuration']
roles = technical_project_configuration['roles']

def docker_testing_where_am_i(argv):
    remote = roles['docker_source_code']

    # check for something like: 'Inside a Docker container built from Dockerfile.source_code'
    execute_command("cat /.inside-docker", {
        "remote": remote,
        "allow_fail": "when we are not inside the Docker container"
    } )

    command_array = [
        "whoami",
        "uname -a",
    ]
    execute_command_array(command_array, { "remote": remote } )


def docker_testing_where_am_i_completions(command, argv):
    completions_hash = {
        "": "",
    }

    return completions_hash


def docker_testing_where_am_i_help(command, argv):
    return f"{command} help page"

