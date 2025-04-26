#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'pwd',
				command_tests => [
						  {
						   description => "Are we in the correct working directory in the Docker container?",
						   read => '/home/neurospaces
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "working directory",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --report-disabled --show',
				command_tests => [
						  {
						   description => "Can we inspect the commands that will be run during the tests?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: workflow-automation-engine
    version: beta
disabled: ~
selected:
  20_vigilia/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests:
        - '1/_1/_1: Are we in the correct working directory in the Docker container ?'
    - description: 'showing that the container works: working directory contents'
      tests:
        - '1/_2/_1: Can we list the working directory in the Docker container ?'
    - description: 'showing that the container works: root directory contents'
      tests:
        - '1/_3/_1: Can we list the root directory in the Docker container ?'

*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands that are tested",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --show-command-tests --report-disabled',
				command_tests => [
						  {
						   description => "Can we inspect the command tests that will be run using the regular options?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: workflow-automation-engine
    version: beta
disabled: ~
selected:
  20_vigilia/30_docker.t:
    - 1/_1/_-1 command: 'pwd '
    - 1/_2/_-1 command: 'ls '
    - 1/_3/_-1 command: ls -1 /

*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands used for the tests using the regular options",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::Formatter::YAML::CommandTests',
				command_tests => [
						  {
						   description => "Can we inspect the command tests that will be run using the YAML output formatter?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: workflow-automation-engine
    version: beta
selected:
  20_vigilia/30_docker.t:
    - 1/_1/_-1 command: 'pwd '
    - 1/_2/_-1 command: 'ls '
    - 1/_3/_-1 command: ls -1 /

*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands used for the tests using the YAML output formatter",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::Formatter::YAML::Summary',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to a YAML formatted summary?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: workflow-automation-engine
    version: beta
selected:
  20_vigilia/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests:
        - '1/_1/_1: Are we in the correct working directory in the Docker container ?'
    - description: 'showing that the container works: working directory contents'
      tests:
        - '1/_2/_1: Can we list the working directory in the Docker container ?'
    - description: 'showing that the container works: root directory contents'
      tests:
        - '1/_3/_1: Can we list the root directory in the Docker container ?'

*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "converting the test specifications to a YAML formatted summary",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::List',
				command_tests => [
						  {
						   comment => "It is not entirely clear what exactly Heterarch::Test::Output::List should do and how it can be useful.",
						   description => "Can we list the constructs used in the test specifications?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: workflow-automation-engine
    version: beta
selected:
  20_vigilia/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests: []
    - description: 'showing that the container works: working directory contents'
      tests: []
    - description: 'showing that the container works: root directory contents'
      tests: []

*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the constructs used in the test specifications",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::Formatter::Latex',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to a latex file?",
						   read => "*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "conversion of the test specifications to latex",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::Formatter::HTMLTable',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to an HTML website?",
						   disabled => "Heterarch::Test::Output::Formatter::HTMLTable is not fully implemented.",
						   read => '*** die: Can\'t locate object method "process" via package "Heterarch::Test::Output::Formatter::HTMLTable" at /usr/local/bin/vigilia line 5165.

*** Info: See \'>/tmp/report_developer.yml\' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "conversion of the test specifications to an HTML website",
			       },
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --regex 30_docker --output Heterarch::Test::Output::Formatter::PDF',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to pdf?",
						   read => "sh: 1: pdflatex: not found
*** Info: See '>/tmp/report_workflow-automation-engine.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "conversion of the test specifications to pdf",
			       },
			      ],
       description => "output formats test module from a prepared container",
       harnessing => {
		      class => {
				comment => 'Enter this container with "docker exec -it vigilia_container bash"',
				docker => {
					   default_user => 'neurospaces',
					   name_container => 'vigilia_container',
					   name_image => 'vigilia-image',
					  },
				identifier => 'docker_container_based_harness',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker::Image',
			       },
		     },
       documentation => {
			 explanation => "

The Neurospaces Harness supports these output formatters:

- Heterarch::Test::Output::Formatter::YAML::CommandTests

  Lists the tested commands.


- Heterarch::Test::Output::Formatter::YAML::Summary

  Lists the detailed descriptions of the tests.


- Heterarch::Test::Output::List

  Lists the summary descriptions of the tests.


- Heterarch::Test::Output::Formatter::Latex

  Converts the test specifications to Latex.


- Heterarch::Test::Output::Formatter::HTMLTable

  This is not fully implemented, but use the stand-alone executable to perform HTML conversion.


- Heterarch::Test::Output::Formatter::PDF

  Uses pdflatex to convert the tests to a pdf file, use this to generate manuals and documentation.

",
			 purpose => "test the different output formatters from a previously prepared container.",
			},
       name => '20_vigilia/41_docker_creator_output_formats.t',
      };

return $test;


