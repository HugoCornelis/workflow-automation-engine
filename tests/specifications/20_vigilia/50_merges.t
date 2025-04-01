#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'cd ~/projects/workflow-automation-engine/source/snapshots/master && vigilia --config-filename ./tests-merge.config --input-modules ./tests/to-be-merged/110_mid-level --input-modules ./tests/to-be-merged/111_low-level --show-command-tests',
				command_tests => [
						  {
						   description => "Can we merge several partial test specifications and then run these merged tests?",
						   read => "
---
description:
  command: /usr/local/bin/vigilia
  name: Test report
  package:
    name: developer-test-merge
    version: alpha
selected:
  111_low-level.t:
    - command: 'ifconfig '
    - command: netstat -rn

*** Info: See '>/tmp/report_developer-test-merge.yml' for the detailed report
No email sent.
/usr/local/bin/vigilia: 0 error(s)
",
						   timeout => 10,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "merging partial test specifications and run them",
			       },
			      ],
       description => "incomplete test specifications and merge of test modules",
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

The Neurospaces Harness allows test specifications to be merged.

Partial (incomplete) test specifications address the need for the
separation of high-level requirement description from intermediary
level function description and low-level testing of an implementation
against requirement and description.

The subsequent merge of the partial test specifications creates a
complete set of test specifications that can be run by the Neurospaces
Harness.

",
			 purpose => "Merging incomplete test specifications",
			},
       name => '20_vigilia/50_merges.t',
      };

return $test;


