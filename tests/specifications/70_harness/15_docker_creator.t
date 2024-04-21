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
				     comment => 'Start a container from this image with "docker run -it neurospaces-developer-image bash"',
				     command => 'docker-snapshot --snapshot-image-name neurospaces-developer-image',
				     command_tests => [
						       {
							description => "Can we take a snapshot of the current Docker container and convert it to an image that has the developer package installed ?",
							read => '',
						       },
						      ],
				     description => "convert the container to an image that has the developer package installed",
				    },
				   ],
	    comment => "docker harness creator module",
	    description => "docker harness create test module",
	    harnessing => {
			   class => {
				     comment => 'Enter this container with "docker exec -it neurospaces_harness_test_container bash"',
				     default_user => 'neurospaces',
				     dockerfile => "./tests/specifications/dockerfiles/Dockerfile.neurospaces-testing",
				     identifier => 'docker_based_harness',
				     name_container => 'neurospaces_harness_test_container',
				     name_image => 'neurospaces_harness_test_image',
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
			      purpose => "Docker test environment.",
			     },
	    name => '70_harness/40_output_formats.t',
	   };

return $test;


