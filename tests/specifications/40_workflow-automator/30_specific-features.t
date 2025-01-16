#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows && workflow builtin install_scripts -- --bash --alias --commands --engine',
				command_tests => [
						  {
						   description => "Can we install the workflow automation configuration for the feature tests?",
						   read => '# mkdir --parents /home/neurospaces/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/tests-workflow
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/tests-configuration /home/neurospaces/bin/./tests-configuration
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/tests-commands /home/neurospaces/bin/tests-commands
#
# ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/tests-commands-features /home/neurospaces/bin/tests-commands-features
#
# bash -c "echo \'# tests-workflow

alias tests-workflow=\"grc tests-workflow\"
alias tests-configuration=\"grc tests-configuration\"
\' | cat >>/home/neurospaces/.bashrc"
#
# bash -c "echo \'. /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/tests-bash-completion.sh
\' | cat >>/home/neurospaces/.bashrc"
#
# sudo     bash -c "echo \'
# tests-workflow
(^|[/\w\.]+/)tests-workflow\s?
conf.tests-workflow

# tests-configuration
(^|[/\w\.]+/)tests-configuration\s?
conf.tests-configuration

\' | cat >>/etc/grc.conf"
#
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/conf.tests-configuration /usr/share/grc/conf.tests-configuration
#
# sudo     ln -sf /home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/configured-workflows/conf.tests-workflow /usr/share/grc/conf.tests-workflow
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
				comment => 'Enter this container with "docker exec -it workflow_features_container bash"',
				default_user => 'neurospaces',
				dockerfile => './tests/specifications/dockerfiles/Dockerfile.workflow-features',
				identifier => 'docker_based_harness_features',
				name_container => 'workflow_features_container',
				name_image => 'workflow_features_image',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
			       },
		     },
       name => '40_workflow-automator/30_specific-features.t',
       tags => [ 'manual' ],
      };


return $test;


