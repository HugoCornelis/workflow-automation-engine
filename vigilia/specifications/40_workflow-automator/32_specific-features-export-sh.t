#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       "0_description" => {
			   features_to_be_tested => {
						     working_directory_changes => {
										   description => "use of 'cd' in shell commands, both remote and local",
										   'localuser@localhost' => 1,
										   tmux => 1,
										   docker => 1,
										   ssh => 1,
										   apply_home_directory => [ 'docker', 'tmux', 'ssh', ],
										  },
						     "bash escapes" => "check where I added explicit support for bash",
						     "execute_shell_script_command()" => 1,
						     "composed roles" => "add this feature, allow ssh within tmux",
						     command_options => {
									 allow_fail => "allow execution of this command to fail.",
									 dry_run => 'do not execute this command.',
									 remote => 'a remote that is defined in units-configuration.',
									 quiet => 'do not provide feedback to the terminal about this command.',
									 sudo => 'invoke the command prefixed with sudo.',
									 timeout => 'this command will fail after the given timeout.',
									 use_bash => 'use bash to invoke the command because it uses specific bash functions or features.',
									 remote => '<name of a remote that is defined in units-configuration>, } );',
									},
						    },
			  },
       commands_to_try => {
			   commands => [
					'cd ~/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing' => 1,

					'workflow builtin install_scripts -- --bash --commands --engine --path-in-bashrc --no-aliasses' => 'does not work',

					'workflow builtin install_scripts -- --no-aliasses --engine --commands' => 'does work',

					'rm -fr ~/bin && rm -f .bashrc',
				       ],
			  },
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing && workflow builtin install_scripts -- --bash --commands --engine --path-in-bashrc --no-aliasses',
				command_tests => [
						  {
						   description => "Can we install the workflow automation configuration for the export-sh feature tests?",
						   read => '# bash -c "echo \'# necessary for $project_name-workflow

export PATH=\"$HOME/bin:$PATH\"

\' | cat >>/home/neurospaces/.bashrc"
#
# mkdir --parents /home/neurospaces/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/feature-testing-workflow
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing/feature-testing-configuration /home/neurospaces/bin/feature-testing-configuration
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

Or / and maybe followed with a command to add or modify a first target, here, for the target named source_code:

feature-testing-workflow builtin add_target source_code Operations on the source code, such as git checkout, build and installation. -- --install-commands-py

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
  - feature-testing-workflow --help-commands
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
						   read => '#!/bin/sh
#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh
#
# --export-remote is not set, exporting all roles without a remote prefix
#
#
# begin export_sh_variables
#

HOME_DIRECTORY=${HOME_DIRECTORY:=/home/neurospaces}

#
# end export_sh_variables
#

pwd
cd /bin
pwd
pwd
cd /bin
pwd
pwd
cd /bin
pwd
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-remote 0',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-remote 0 (all roles)?",
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
				description => "correct information about the generated output file when using the --export-sh option, --export-remote 0 (all roles)",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-remote 0 (all roles)?",
						   read => '#!/bin/sh
#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-remote 0
#
# --export-remote is 0, exporting all roles with the appriopriate remote prefix
#
#
# begin export_sh_variables
#

HOME_DIRECTORY=${HOME_DIRECTORY:=/home/neurospaces}

#
# end export_sh_variables
#

pwd
cd /bin
pwd
sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    pwd
sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    cd /bin
sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin && pwd\'
tmux send-keys -t cd    \'pwd\' ENTER
tmux send-keys -t cd    \'cd /bin\' ENTER
tmux send-keys -t cd    \'pwd\' ENTER
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-remote 0 (all roles)",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-remote 1',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-remote 1?",
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
				description => "correct information about the generated output file when using the --export-sh option, --export-remote 1",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-remote 1?",
						   read => '#!/bin/sh
#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-remote 1
#
# --export-remote is 1, role: localuser@localhost
#
#
# begin export_sh_variables
#

HOME_DIRECTORY=${HOME_DIRECTORY:=/home/neurospaces}

#
# end export_sh_variables
#

pwd
cd /bin
pwd
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>
# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
# <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>
# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-remote 1",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-remote 2',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-remote 2?",
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
				description => "correct information about the generated output file when using the --export-sh option, --export-remote 2",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-remote 2?",
						   read => '#!/bin/sh
#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-remote 2
#
# --export-remote is 2, role: root@ssh_cd
#
#
# begin export_sh_variables
#

HOME_DIRECTORY=${HOME_DIRECTORY:=/home/neurospaces}

#
# end export_sh_variables
#

# <local command: pwd>
# <local command: cd /bin>
# <local command: pwd>
pwd
cd /bin
cd /bin && pwd
# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
# <remote command at tmux send-keys -t cd : \'cd /bin\' ENTER>
# <remote command at tmux send-keys -t cd : \'pwd\' ENTER>
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-remote 2",
			       },
			       {
				command => 'feature-testing-workflow features export_sh --export-sh --export-remote 3',
				command_tests => [
						  {
						   description => "Do we see correct information about the generated output file when using the --export-sh option, --export-remote 3?",
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
				description => "correct information about the generated output file when using the --export-sh option, --export-remote 3",
			       },
			       {
				command => 'cat features-export-sh.sh',
				command_tests => [
						  {
						   description => "What is the contents of the generated output file after using the --export-sh option, --export-remote 3?",
						   read => '#!/bin/sh
#
# script generated with feature-testing-workflow
#
# the command line used to generate this script was:
#
# /home/neurospaces/bin/feature-testing-workflow features export_sh --export-sh --export-remote 3
#
# --export-remote is 3, role: tmux_cd
#
#
# begin export_sh_variables
#

HOME_DIRECTORY=${HOME_DIRECTORY:=/home/neurospaces}

#
# end export_sh_variables
#

# <local command: pwd>
# <local command: cd /bin>
# <local command: pwd>
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : pwd>
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : cd /bin>
# <remote command at sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__ : \'cd /bin && pwd\'>
pwd
cd /bin
pwd
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "contents of the generated output file after using the --export-sh option, --export-remote 3",
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


