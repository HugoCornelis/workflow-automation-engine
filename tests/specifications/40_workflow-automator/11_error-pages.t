#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'workflow --non-existent-option',
				command_tests => [
						  {
						   description => "Do we get a sensible error message when an non-existent target is invoked ?",
						   read => 'Unknown option: non-existent-option
workflow: *** error in option processing, try --help at /usr/local/bin/workflow line 5757.
 at /usr/local/bin/workflow line 5757.
	main::parse_command_line() called at /usr/local/bin/workflow line 5406
	main::main() called at /usr/local/bin/workflow line 6187
workflow: *** error in option processing, try --help at /usr/local/bin/workflow line 5757.
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "the error message when invoking a non-existent target",
			       },
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
			       {
				command => 'workflow builtin mosart-beethoven',
				command_tests => [
						  {
						   description => "Do we get a sensible error message when an non-existent command is invoked ?",
						   read => 'workflow: *** Error: Either target \'builtin\' does not exist or it does not provide command \'mosart-beethoven\'. at /usr/local/bin/workflow line 5742.
 at /usr/local/bin/workflow line 5742.
	main::main() called at /usr/local/bin/workflow line 6187
workflow: *** Error: Either target \'builtin\' does not exist or it does not provide command \'mosart-beethoven\'. at /usr/local/bin/workflow line 5742.
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "the error message when invoking a non-existent target",
			       },
			       {
				command => 'workflow builtin install_scripts -- --non-existent-option',
				command_tests => [
						  {
						   description => "Do we get a sensible error message when an non-existent command is invoked ?",
						   read => 'Unknown option: non-existent-option
workflow: *** error in option processing, try --help at /usr/local/bin/workflow line 1890.
 at /usr/local/bin/workflow line 1890.
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
				comment => 'Enter this container with "docker exec -it workflow_automation_test_container_errors bash"',
				default_user => 'neurospaces',
				identifier => 'docker_based_harness_errors',
				name_container => 'workflow_automation_test_container_errors',
				name_image => 'workflow_automation_image_errors',
				type => '',
			       },
		     },
       name => '40_workflow-automator/11_error-pages.t',
      };


return $test;


