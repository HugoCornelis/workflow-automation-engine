#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master/vigilia/specifications/workflow-configurations/feature-testing && workflow builtin install_scripts -- --bash --commands --path-in-bashrc --no-aliasses',
				command_tests => [
						  {
						   description => "Can we install the workflow automation configuration for the annotation feature tests?",
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
				description => "installing the workflow automation configuration for the annotation feature tests",
			       },
			       {
				command => 'feature-testing-workflow features annotations',
				command_tests => [
						  {
						   description => "Do we see the annotations when executing a command that uses them?",
						   read => "
### Three commands, one changes the current working directory.
# pwd
#
/home/neurospaces
# cd /bin
#
# pwd
#
/usr/bin
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct changes in directory during a workflow execution that uses the 'cd' command",
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
       name => '40_workflow-automator/34_specific-features-annotations.t',
      };


return $test;


