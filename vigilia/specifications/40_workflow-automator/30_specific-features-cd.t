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
						   description => "Can we install the workflow automation configuration for the cd feature tests?",
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
				description => "installing the workflow automation configuration for the cd feature tests",
			       },
			       {
				command => 'workflow --help-projects',
				command_tests => [
						  {
						   description => "Can we find the workflow project for the cd feature tests?",
						   read => 'available_workflow automation projects (copy-paste the one you would like to get help for):
  - feature-testing-workflow --help-commands
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "find the workflow project for the cd feature tests",
			       },
			       {
				command => 'feature-testing-workflow',
				command_tests => [
						  {
						   description => "Do we get a reasonable error message when invoking the engine without arguments?",
						   read => 'feature-testing-workflow: *** Error: neither a target option nor target argument given, try --help',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "reasonable error message when invoking the engine without arguments",
			       },
			       {
				command => 'feature-testing-workflow perl_examples single_command',
				command_tests => [
						  {
						   description => "Do we get the template response when inoking the engine with a pre-configured example command?",
						   read => 'an example of the invocation of a single command',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "template response when inoking the engine with a pre-configured example command",
			       },
			       {
				command => 'feature-testing-workflow features cd_tests',
				command_tests => [
						  {
						   description => "Do we see correct changes in directory during a workflow execution that uses the 'cd' command?",
						   read => "# pwd
#
/home/neurospaces
# cd bin
#
# pwd
#
/home/neurospaces/bin
# cd ..
#
# pwd
#
/home/neurospaces
# cd /
#
# pwd
#
/
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct changes in directory during a workflow execution that uses the 'cd' command",
			       },
			       {
				command => 'feature-testing-workflow builtin tmux_create_sessions',
				command_tests => [
						  {
						   description => "Can we create the tmux sessions for testing workflow cd commands?",
						   read => "# tmux new-session -d -s cd
#
# tmux new-session -d -s ssh_cd
#
# echo For tmux session cd, attach with: 'tmux attach-session -t cd'
#
For tmux session cd, attach with: tmux attach-session -t cd
# echo For tmux session ssh_cd, attach with: 'tmux attach-session -t ssh_cd'
#
For tmux session ssh_cd, attach with: tmux attach-session -t ssh_cd
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "create the tmux sessions for testing workflow cd commands",
			       },
			       {
				command => 'tmux ls',
				command_tests => [
						  {
						   description => "Have the tmux sessions been created?",
						   read => [ '-re', "cd: 1 windows \(created [^\)]*\)
ssh_cd: 1 windows \(created [^\)]*\)
", ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "check if the tmux sessions have been created",
				disabled => 'the regex does not work',
			       },
			       {
				command => 'feature-testing-workflow features cd_tests_tmux',
				command_tests => [
						  {
						   description => "Do we see correct changes in directory during a workflow execution in a tmux session that uses the 'cd' command?",
						   read => "# tmux send-keys -t cd    'pwd >>/tmp/tmux-pwd.txt' ENTER
#
# tmux send-keys -t cd    'cd bin' ENTER
#
# tmux send-keys -t cd    'pwd >>/tmp/tmux-pwd.txt' ENTER
#
# tmux send-keys -t cd    'cd ..' ENTER
#
# tmux send-keys -t cd    'pwd >>/tmp/tmux-pwd.txt' ENTER
#
# tmux send-keys -t cd    'cd /' ENTER
#
# tmux send-keys -t cd    'pwd >>/tmp/tmux-pwd.txt' ENTER
#
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct changes in directory during a workflow execution that uses the 'cd' command in a tmux session",
			       },
			       {
				command => 'cat /tmp/tmux-pwd.txt',
				command_tests => [
						  {
						   description => "Do we see the correct changes in the working directory after a workflow execution in a tmux session that uses the 'cd' command?",
						   read => "/home/neurospaces
/home/neurospaces/bin
/home/neurospaces
/
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "the correct changes in directory after a workflow execution that uses the 'cd' command in a tmux session",
			       },
			       {
				comments => '
This was taken from:

https://satvikakolisetty.medium.com/running-ssh-server-in-a-docker-container-55eb2a3add35

FROM ubuntu:latest
RUN apt-get update && apt-get install -y openssh-server
# Configure SSH
RUN mkdir /var/run/sshd
RUN echo \'root:redhat\' | chpasswd
#password for user login
RUN sed -i \'s/#PermitRootLogin prohibit-password/PermitRootLogin yes/\' /etc/ssh/sshd_config
EXPOSE 22
# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]

https://circleci.com/blog/ssh-into-docker-container/#c-consent-modal

FROM ubuntu:20.04

RUN apt update && apt install -y openssh-server
RUN sed -i \'s/PermitRootLogin prohibit-password/PermitRootLogin yes/\' /etc/ssh/sshd_config

RUN useradd -m -s /bin/bash bilbo
RUN echo "bilbo:insecure_password" | chpasswd

EXPOSE 22

ENTRYPOINT service ssh start && bash

Then:

$ docker inspect --format=\'{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}\' workflow_feature_testing_container
172.17.0.2


',
				command => 'feature-testing-workflow features cd_tests_ssh',
				command_tests => [
						  {
						   comment => 'this test connects from inside the container to that same container',
						   description => "Do we see correct changes in directory during a workflow execution in an ssh session that uses the 'cd' command?",
						   read => '# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    pwd
#
/root
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    cd /bin
#
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin && pwd\'
#
/bin
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin && cd ..\'
#
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin/.. && pwd\'
#
/
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd /bin/.. && cd /\'
#
# sshpass -p harness ssh -o LogLevel=ERROR -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 22 root@__DOCKER_HOST_IP_ADDRESS__    \'cd / && pwd\'
#
/
',
						   timeout => 10,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct changes in directory during a workflow execution that uses the 'cd' command in an ssh session",
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
				comment => 'Enter this container with "docker exec -it workflow_feature_testing_container bash", note that it has a fixed ip address of 172.18.0.22 as assumed by the test scripts',
				description => '
This class instantiates a docker image based on the given docker file, then runs a container based on that image.

The name of image and the name of the container are controlled from the class properties.

The class properties can include IP network information and IP address of the container.
',
				docker => {
					   default_user => 'neurospaces',
					   dockerfile => './vigilia/specifications/dockerfiles/Dockerfile.workflow-feature-testing',
					   # 				ip_address_container => "172.17.0.2",
					   name_container => 'workflow_feature_testing_container',
					   name_image => 'workflow_feature_testing_image',
					  },
				identifier => 'docker_harness_feature_testing',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
			       },
		     },
       name => '40_workflow-automator/30_specific-features-cd.t',
      };


return $test;


