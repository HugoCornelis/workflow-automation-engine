#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'workflow start_project mosart-beethoven',
				command_tests => [
						  {
						   description => "Do we get a sensible error message when an non-existent target is invoked ?",
						   read => 'workflow: *** Error: Either target \'start_project\' does not exist or it does not provide command \'mosart-beethoven\'. at /usr/local/bin/workflow line 5742.
 at /usr/local/bin/workflow line 5742.
	main::main() called at /usr/local/bin/workflow line 6187
workflow: *** Error: Either target \'start_project\' does not exist or it does not provide command \'mosart-beethoven\'. at /usr/local/bin/workflow line 5742.
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "the error message when invoking a non-existent target",
			       },
			      ],
       description => "error pages",
       documentation => {
			 explanation => "

The workflow script enables the automation of customizable modular
project-specific workflows that use system shell commands.

",
			 purpose => "This module tests the basic error messages of the workflow automation engine.",
			},
       harnessing => {
		      class => {
				build => "./tests/specifications/dockerfiles/docker-build-errors.bash",
				comment => 'Enter this container with "sudo docker exec -it workflow_automation_test_container_errors bash"',
				default_user => 'neurospaces',
				identifier => 'docker_based_harness_errors',
				name_container => 'workflow_automation_test_container_errors',
				name_image => 'workflow_automation_image_errors',
				type => '',
			       },
		     },
       harnessing2 => {
		      preparation => {
				      description => "create and enter the directory for running the tests",
				      preparer =>
				      sub
				      {
					  system "rm -fr tmp";
					  system "mkdir tmp";
					  chdir "tmp";

					  # return no errors

					  return '';
				      },
				     },
		      reparation => {
				     description => "leave and remove the directory for running the tests",
				     reparer =>
				     sub
				     {
					 chdir "..";
					 # system "rm -fr tmp";

					 # return no errors

					 return '';
				     },
				    },
		     },
       name => '40_workflow-automator/11_error-pages.t',
      };


return $test;


