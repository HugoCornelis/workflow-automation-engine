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
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing && workflow builtin install_scripts -- --bash --alias --commands --engine',
				command_tests => [
						  {
						   description => "Can we install the workflow automation configuration for the feature tests?",
						   read => '# mkdir --parents /home/neurospaces/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/feature-testing-workflow
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/feature-testing-configuration /home/neurospaces/bin/./feature-testing-configuration
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/feature-testing-commands-perl_examples /home/neurospaces/bin/feature-testing-commands-perl_examples
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/feature-testing-commands-python_examples /home/neurospaces/bin/feature-testing-commands-python_examples
#
# bash -c "echo \'# feature-testing-workflow

alias feature-testing-workflow=\"grc feature-testing-workflow\"
alias feature-testing-configuration=\"grc feature-testing-configuration\"
\' | cat >>/home/neurospaces/.bashrc"
#
# bash -c "echo \'. /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/feature-testing-bash-completion.sh
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
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/conf.feature-testing-configuration /usr/share/grc/conf.feature-testing-configuration
#
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/conf.feature-testing-workflow /usr/share/grc/conf.feature-testing-workflow
#
',
						   wait => 2,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "installing the workflow automation configuration for the feature tests",
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
				comment => 'Enter this container with "docker exec -it workflow_feature_testing_container bash"',
				default_user => 'neurospaces',
				dockerfile => './tests/specifications/dockerfiles/Dockerfile.workflow-feature-testing',
				identifier => 'docker_based_harness_feature_testing',
				name_container => 'workflow_feature_testing_container',
				name_image => 'workflow_feature_testing_image',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
			       },
		     },
       name => '40_workflow-automator/30_specific-features.t',
       tags => [ 'manual' ],
      };


return $test;


