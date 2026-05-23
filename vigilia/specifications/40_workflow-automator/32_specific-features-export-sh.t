#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing && workflow builtin configuration_install -- --bash --commands --engine --path-in-bashrc --no-aliasses',
				command_tests => [
						  {
						   description => "Can we install the workflow automation configuration for the export-sh feature tests?",
						   read => '# bash -c "echo \'# necessary for feature-testing-workflow

export PATH=\"$HOME/bin:$PATH\"

\' | cat >>/home/neurospaces/.bashrc"
#
# mkdir --parents /home/neurospaces/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/feature-testing-workflow
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-configuration /home/neurospaces/bin/feature-testing-configuration
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-build /home/neurospaces/bin/feature-testing-commands-build
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-docker_testing.py /home/neurospaces/bin/feature-testing-commands-docker_testing.py
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-features /home/neurospaces/bin/feature-testing-commands-features
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-more_python.py /home/neurospaces/bin/feature-testing-commands-more_python.py
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-perl_examples /home/neurospaces/bin/feature-testing-commands-perl_examples
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-commands-python.py /home/neurospaces/bin/feature-testing-commands-python.py
#
# bash -c "echo \'. /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-bash-completion.sh
\' | cat >>/home/neurospaces/.bashrc"
#
# sudo     bash -c "echo \'
# feature-testing-workflow
(^|[/\w\.]+/)feature-testing-workflow\s?
conf.feature-testing-workflow

# feature-testing-configuration
(^|[/\w\.]+/)feature-testing-configuration\s?
conf.feature-testing-configuration

\' | cat >>/etc/grc.conf"
#
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/conf.feature-testing-configuration /usr/share/grc/conf.feature-testing-configuration
#
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/conf.feature-testing-workflow /usr/share/grc/conf.feature-testing-workflow
#

Bash completion can be enabled using:

. ./feature-testing-bash-completion.sh

Or/and maybe followed with a command to add or modify a first target, here, for the target named source_code:

feature-testing-workflow builtin target_add source_code "Operations on the source code, such as git checkout, build and installation." -- --install-commands-py

',
						   wait => 2,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "installing the workflow automation configuration for the export-sh feature tests",
			       },
			       {
				command => 'workflow --help-projects',
				command_tests => [
						  {
						   description => "Can we find the workflow project for the export-sh feature tests?",
						   read => 'available_workflow automation projects (copy-paste the one you would like to get help for):
  - feature-testing-workflow --help-workflows
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "find the workflow project for the export-sh feature tests",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option?",
						   read => 'feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct information about the generated output file when using the --export-sh option",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option?",
						   read => '#!/bin/bash

# -e: exit immediately if any command returns a non-zero exit status
# -u: undefined variable causes the script to exit immediately
# -o pipefail: a pipeline fails if any command in the pipeline fails
set -euo pipefail

#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh
#

while [[ ${1-} != "" ]]; do
  case "$1" in
    -d|--dry-run) RUN_DRY_RUN=1; shift ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [-h|--help]



Options:
  -d, --dry-run Do not run commands but show them if verbose is set.
  -h, --help    Show this help
  -v, --verbose Run in verbose mode (display commands as they are executed)
EOF
      exit 0
      ;;
    -v|--verbose) RUN_VERBOSE=1; shift ;;
    *) echo "Unknown argument: $1"; exit 2 ;;
  esac
done


# running mode defaults
RUN_VERBOSE=0
RUN_DRY_RUN=0


# run a command, implement RUN_VERBOSE and RUN_DRY_RUN.
# Usage: do_run_command command arg1 arg2 ...
do_run_command() {
    if [[ ${RUN_VERBOSE:-0} == 1 ]]; then
        echo "$@"
    fi

    if [[ ${RUN_DRY_RUN:-0} == 0 ]]; then
        "$@"
    fi
}

# --export-role is not set, exporting all roles without a remote policy prefix
#
#
# no variables of export_sh_variables have been selected for export
#

do_run_command pwd
do_run_command cd /bin
do_run_command pwd
do_run_command pwd
do_run_command cd /bin
do_run_command pwd
do_run_command pwd
do_run_command cd /bin
do_run_command pwd
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-role 0',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-role 0 (all roles)?",
						   read => 'feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin && pwd\'\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'tmux send-keys -t cd    \'pwd\' ENTER\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'tmux send-keys -t cd    \'cd /bin\' ENTER\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'tmux send-keys -t cd    \'pwd\' ENTER\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct information about the generated output file when using the --export-sh option, --export-role 0 (all roles)",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-role 0 (all roles)?",
						   read => '#!/bin/bash

# -e: exit immediately if any command returns a non-zero exit status
# -u: undefined variable causes the script to exit immediately
# -o pipefail: a pipeline fails if any command in the pipeline fails
set -euo pipefail

#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-role 0
#

while [[ ${1-} != "" ]]; do
  case "$1" in
    -d|--dry-run) RUN_DRY_RUN=1; shift ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [-h|--help]



Options:
  -d, --dry-run Do not run commands but show them if verbose is set.
  -h, --help    Show this help
  -v, --verbose Run in verbose mode (display commands as they are executed)
EOF
      exit 0
      ;;
    -v|--verbose) RUN_VERBOSE=1; shift ;;
    *) echo "Unknown argument: $1"; exit 2 ;;
  esac
done


# running mode defaults
RUN_VERBOSE=0
RUN_DRY_RUN=0


# run a command, implement RUN_VERBOSE and RUN_DRY_RUN.
# Usage: do_run_command command arg1 arg2 ...
do_run_command() {
    if [[ ${RUN_VERBOSE:-0} == 1 ]]; then
        echo "$@"
    fi

    if [[ ${RUN_DRY_RUN:-0} == 0 ]]; then
        "$@"
    fi
}

# --export-role is 0, exporting all roles with the appriopriate remote policy prefix
#
#
# no variables of export_sh_variables have been selected for export
#

do_run_command pwd
do_run_command cd /bin
do_run_command pwd
do_run_command sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    pwd
do_run_command sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    cd /bin
do_run_command sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin && pwd\'
do_run_command tmux send-keys -t cd    \'pwd\' ENTER
do_run_command tmux send-keys -t cd    \'cd /bin\' ENTER
do_run_command tmux send-keys -t cd    \'pwd\' ENTER
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-role 0 (all roles)",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-role 1',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-role 1?",
						   read => 'feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct information about the generated output file when using the --export-sh option, --export-role 1",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-role 1?",
						   read => '#!/bin/bash

# -e: exit immediately if any command returns a non-zero exit status
# -u: undefined variable causes the script to exit immediately
# -o pipefail: a pipeline fails if any command in the pipeline fails
set -euo pipefail

#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-role 1
#

while [[ ${1-} != "" ]]; do
  case "$1" in
    -d|--dry-run) RUN_DRY_RUN=1; shift ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [-h|--help]



Options:
  -d, --dry-run Do not run commands but show them if verbose is set.
  -h, --help    Show this help
  -v, --verbose Run in verbose mode (display commands as they are executed)
EOF
      exit 0
      ;;
    -v|--verbose) RUN_VERBOSE=1; shift ;;
    *) echo "Unknown argument: $1"; exit 2 ;;
  esac
done


# running mode defaults
RUN_VERBOSE=0
RUN_DRY_RUN=0


# run a command, implement RUN_VERBOSE and RUN_DRY_RUN.
# Usage: do_run_command command arg1 arg2 ...
do_run_command() {
    if [[ ${RUN_VERBOSE:-0} == 1 ]]; then
        echo "$@"
    fi

    if [[ ${RUN_DRY_RUN:-0} == 0 ]]; then
        "$@"
    fi
}

# --export-role is 1, role: localuser@localhost
#
#
# no variables of export_sh_variables have been selected for export
#

do_run_command pwd
do_run_command cd /bin
do_run_command pwd
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>
do_run_command # <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
do_run_command # <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>
do_run_command # <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-role 1",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-role 2',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-role 2?",
						   read => 'feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: cd /bin>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin && pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct information about the generated output file when using the --export-sh option, --export-role 2",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-role 2?",
						   read => '#!/bin/bash

# -e: exit immediately if any command returns a non-zero exit status
# -u: undefined variable causes the script to exit immediately
# -o pipefail: a pipeline fails if any command in the pipeline fails
set -euo pipefail

#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-role 2
#

while [[ ${1-} != "" ]]; do
  case "$1" in
    -d|--dry-run) RUN_DRY_RUN=1; shift ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [-h|--help]



Options:
  -d, --dry-run Do not run commands but show them if verbose is set.
  -h, --help    Show this help
  -v, --verbose Run in verbose mode (display commands as they are executed)
EOF
      exit 0
      ;;
    -v|--verbose) RUN_VERBOSE=1; shift ;;
    *) echo "Unknown argument: $1"; exit 2 ;;
  esac
done


# running mode defaults
RUN_VERBOSE=0
RUN_DRY_RUN=0


# run a command, implement RUN_VERBOSE and RUN_DRY_RUN.
# Usage: do_run_command command arg1 arg2 ...
do_run_command() {
    if [[ ${RUN_VERBOSE:-0} == 1 ]]; then
        echo "$@"
    fi

    if [[ ${RUN_DRY_RUN:-0} == 0 ]]; then
        "$@"
    fi
}

# --export-role is 2, role: root@ssh_cd
#
#
# no variables of export_sh_variables have been selected for export
#

do_run_command # <local command: pwd>
do_run_command # <local command: cd /bin>
do_run_command # <local command: pwd>
do_run_command pwd
do_run_command cd /bin
do_run_command cd /bin && pwd
do_run_command # <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
do_run_command # <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>
do_run_command # <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-role 2",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-role 3',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-role 3?",
						   read => 'feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: cd /bin>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <local command: pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'cd /bin\'
feature-testing-workflow: *** Running in export_sh mode, exporting: \'pwd\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct information about the generated output file when using the --export-sh option, --export-role 3",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-role 3?",
						   read => '#!/bin/bash

# -e: exit immediately if any command returns a non-zero exit status
# -u: undefined variable causes the script to exit immediately
# -o pipefail: a pipeline fails if any command in the pipeline fails
set -euo pipefail

#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-role 3
#

while [[ ${1-} != "" ]]; do
  case "$1" in
    -d|--dry-run) RUN_DRY_RUN=1; shift ;;
    -h|--help)
      cat <<EOF
Usage: $(basename "$0") [-h|--help]



Options:
  -d, --dry-run Do not run commands but show them if verbose is set.
  -h, --help    Show this help
  -v, --verbose Run in verbose mode (display commands as they are executed)
EOF
      exit 0
      ;;
    -v|--verbose) RUN_VERBOSE=1; shift ;;
    *) echo "Unknown argument: $1"; exit 2 ;;
  esac
done


# running mode defaults
RUN_VERBOSE=0
RUN_DRY_RUN=0


# run a command, implement RUN_VERBOSE and RUN_DRY_RUN.
# Usage: do_run_command command arg1 arg2 ...
do_run_command() {
    if [[ ${RUN_VERBOSE:-0} == 1 ]]; then
        echo "$@"
    fi

    if [[ ${RUN_DRY_RUN:-0} == 0 ]]; then
        "$@"
    fi
}

# --export-role is 3, role: tmux_cd
#
#
# no variables of export_sh_variables have been selected for export
#

do_run_command # <local command: pwd>
do_run_command # <local command: cd /bin>
do_run_command # <local command: pwd>
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>
do_run_command # <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>
do_run_command pwd
do_run_command cd /bin
do_run_command pwd
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-role 3",
			       },
			      ],
       description => "testing the workflow automation engine",
       documentation => {
			 explanation => "

The workflow script enables the automation of customizable modular
project-specific workflows consisting of shell commands.

",
			 purpose => "This module tests specific features of the workflow automation engine.",
			},
       harnessing => {
		      class => {
				comment => 'Enter this container with "docker exec -it workflow_feature_testing_container bash".',
				description => '
This class instantiates a docker image based on the given docker file, then runs a container based on that image.

The name of image and the name of the container are controlled from the class properties.

The class properties can include IP network information and IP address of the container.
',
				docker => {
					   default_user => 'neurospaces',
					   dockerfile => './vigilia/specifications/dockerfiles/Dockerfile.workflow-feature-testing',
					   name_container => 'workflow_feature_testing_container',
					   name_image => 'workflow_feature_testing_image',
					  },
				identifier => 'docker_harness_feature_testing',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
			       },
		     },
       name => '40_workflow-automator/32_specific-features-export-sh.t',
      };


return $test;


