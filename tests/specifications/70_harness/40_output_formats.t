#!/usr/bin/perl -w
#

use strict;


my $test = {
	    command_definitions => [
				    {
				     command => 'pwd',
				     command_tests => [
						       {
							description => "Are we in the correct working directory in the Docker container ?",
							read => '/home/neurospaces
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: working directory",
				    },
				    {
				     command => 'cd ~/projects/developer/source/snapshots/master && tar xfz cpan/02-Mo-0.40.tar.gz && cd Mo-0.40 && perl Makefile.PL && make && sudo make install',
				     command_tests => [
						       {
							comment => 'perl installation seems to be non-deterministic, only checking a part of the output',
							description => "Can we install the Mo cpan module ?",
							read => 'Installing /usr/local/bin/mo-inline
Appending installation info to /usr/local/lib/x86_64-linux-gnu/perl/5.36.0/perllocal.pod
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "cpan installation of Mo",
				    },
				    {
				     command => 'cd ~/projects/developer/source/snapshots/master && tar xfz cpan/13-Data-Utilities-0.04.tar.gz && cd Data-Utilities-0.04 && perl Makefile.PL && make && sudo make install',
				     command_tests => [
						       {
							comment => 'perl installation seems to be non-deterministic, only checking a part of the output',
							description => "Can we install the Data::Utilities cpan module ?",
							read => 'Appending installation info to /usr/local/lib/x86_64-linux-gnu/perl/5.36.0/perllocal.pod
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "cpan installation of Data::Utilities",
				    },
				    {
				     command => 'cd ~/projects/developer/source/snapshots/master && ./configure && make && sudo make install',
				     command_tests => [
						       {
							description => "Can we install the developer package in the Docker container ?",
							read => 'Developer package installation finished',
							timeout => 5,
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: installing the Developer package in the Docker container",
				    },
				    {
				     command => 'docker-snapshot --snapshot-image-name testing-developer-package',
				     command_tests => [
						       {
							description => "Can we take a snapshot of the current Docker container and convert it to an image ?",
							read => '',
						       },
						      ],
				     description => "convert the container to an image",
				    },
				    {
				     command => 'cd ~/projects/developer/source/snapshots/master && neurospaces_harness --regex 30_docker --report-disabled --show',
				     command_tests => [
						       {
							description => "Can we inspect the commands that will be run during the tests ?",
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
							description => "Can we inspect the command tests that will be run using the regular options ?",
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
							description => "Can we inspect the command tests that will be run using the YAML output formatter ?",
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
							description => "Can we convert the test specifications to a YAML formatted summary ?",
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
							description => "Can we list the constructs used in the test specifications ?",
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
							description => "Can we convert the test specifications to a latex file ?",
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
							description => "Can we convert the test specifications to an HTML website ?",
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
							description => "Can we convert the test specifications to pdf ?",
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
	    description => "output formats test module",
	    harnessing => {
			   class => {
				     comment => 'Enter this container with "docker exec -it neurospaces_harness_test_container bash"',
				     docker => {
						default_user => 'neurospaces',
						dockerfile => "./tests/specifications/dockerfiles/Dockerfile.neurospaces-testing",
						name_container => 'neurospaces_harness_test_container',
						name_image => 'neurospaces_harness_test_image',
					       },
				     identifier => 'docker_based_harness',
				     type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
				    },
			  },
	    documentation => {
			      explanation => "

The Neurospaces Harness automates unit, regression, integration and
smoke testing.  Declarative test specifications define application
behaviour and are used to execute tests.

Specific clauses in these specifications are used to prepare and
restore the test environment prior to test execution.

This test module tests the different output formatters that allow to
convert test specifications to documentation.

",
			      purpose => "Tests for the different output formats.",
			     },
	    name => '70_harness/40_output_formats.t',
	   };

return $test;


