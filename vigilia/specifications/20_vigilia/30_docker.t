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
				     command => 'ls',
				     command_tests => [
						       {
							description => "Can we list the working directory in the Docker container ?",
							read => 'projects
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: working directory contents",
				    },
				    {
				     command => 'ls -1 /',
				     command_tests => [
						       {
							description => "Can we list the root directory in the Docker container ?",
							read => 'bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: root directory contents",
				    },
				   ],
	    comment => "docker harness tests",
	    description => "docker harness test module",
	    harnessing => {
			   class => {
				     comment => 'Enter this container with "docker exec -it vigilia_test_container bash"',
				     docker => {
						default_user => 'neurospaces',
						dockerfile => "./vigilia/specifications/dockerfiles/Dockerfile.neurospaces-testing",
						name_container => 'vigilia_test_container',
						name_image => 'vigilia_test_image',
					       },
				     identifier => 'docker_harness_3',
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

This test module implement tests that use a docker container to
separate the test environment from the developer's environment.

",
			      purpose => "Docker test environment.",
			     },
	    name => '20_vigilia/30_docker.t',
	   };

return $test;


