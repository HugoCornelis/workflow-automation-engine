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
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --report-disabled --show',
				command_tests => [
						  {
						   description => "Can we inspect the commands that will be run during the tests?",
						   read => "
---
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
disabled: ~
selected:
  70_harness/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests:
        - Are we in the correct working directory in the Docker container ?
    - description: 'showing that the container works: working directory contents'
      tests:
        - Can we list the working directory in the Docker container ?
    - description: 'showing that the container works: root directory contents'
      tests:
        - Can we list the root directory in the Docker container ?

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands that are tested",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --show-command-tests --report-disabled',
				command_tests => [
						  {
						   description => "Can we inspect the command tests that will be run using the regular options?",
						   read => "
---
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
disabled: ~
selected:
  70_harness/30_docker.t:
    - command: 'pwd '
    - command: 'ls '
    - command: ls -1 /

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands used for the tests using the regular options",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::Formatter::YAML::CommandTests',
				command_tests => [
						  {
						   description => "Can we inspect the command tests that will be run using the YAML output formatter?",
						   read => "
---
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
selected:
  70_harness/30_docker.t:
    - command: 'pwd '
    - command: 'ls '
    - command: ls -1 /

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the commands used for the tests using the YAML output formatter",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::Formatter::YAML::Summary',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to a YAML formatted summary?",
						   read => "
---
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
selected:
  70_harness/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests:
        - Are we in the correct working directory in the Docker container ?
    - description: 'showing that the container works: working directory contents'
      tests:
        - Can we list the working directory in the Docker container ?
    - description: 'showing that the container works: root directory contents'
      tests:
        - Can we list the root directory in the Docker container ?

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "converting the test specifications to a YAML formatted summary",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::List',
				command_tests => [
						  {
						   comment => "It is not entirely clear what exactly Heterarch::Test::Output::List should do and how it can be useful.",
						   description => "Can we list the constructs used in the test specifications?",
						   read => "
---
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
selected:
  70_harness/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests: []
    - description: 'showing that the container works: working directory contents'
      tests: []
    - description: 'showing that the container works: root directory contents'
      tests: []

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "inspecting the constructs used in the test specifications",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::Formatter::Latex',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to a latex file?",
						   read => "*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "conversion of the test specifications to latex",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::Formatter::HTMLTable',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to an HTML website?",
						   disabled => "Heterarch::Test::Output::Formatter::HTMLTable is not fully implemented.",
						   read => '*** die: Can\'t locate object method "process" via package "Heterarch::Test::Output::Formatter::HTMLTable" at /usr/local/bin/neurospaces_harness line 5165.

*** Info: See \'>/tmp/report_developer.yml\' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "conversion of the test specifications to an HTML website",
			       },
			       {
				command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --output Heterarch::Test::Output::Formatter::PDF',
				command_tests => [
						  {
						   description => "Can we convert the test specifications to pdf?",
						   read => "sh: 1: pdflatex: not found
*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
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
				comment => 'Enter this container with "docker exec -it neurospaces_developer_package_test_container bash"',
				default_user => 'neurospaces',
				identifier => 'docker_container_based_harness',
				name_container => 'neurospaces_developer_package_test_container',
				name_image => 'neurospaces-developer-image',
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
       name => '70_harness/41_docker_creator_output_formats.t',
      };

return $test;


