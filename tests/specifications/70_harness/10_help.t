#!/usr/bin/perl -w
#

use strict;


my $test = {
	    command_definitions => [
				    {
				     arguments => [
						   '--help',
						  ],
				     command => 'bin/neurospaces_harness',
				     command_tests => [
						       {
							description => "Is a help message given ?",
							read => "
bin/neurospaces_harness: test definition executor

options:
    --dump-json          dump test specifications to json files in /tmp/.
    --dump-perl          dump test specifications to perl files in /tmp/.
    --dump-yaml          dump test specifications to yaml files in /tmp/.
    --email              allow to send emails, the default is taken from \$ENV{NEUROSPACES_HARNESS_OPTION_EMAIL}.
    --flattenout         flattenout the test definitions before testing,
                         this experimental feature might increase test performance,
                         by recycling test definitions.
    --help               print usage information.
    --numerical-compare  attempt to compare numbers numerically when string differences are found (default enabled).
    --randomize-order    randomize the order of the tests before executing them (require List::Util to be installed).
    --regex-selector     defines a regex to run specific tests.
    --report-disabled    include information of disabled tests in the test report.
    --report-mac         include information of disabled tests on Mac OSX.
    --show               show tests that would be run using the current configuration.
    --tags               only test test modules that have been tagged with these tags (default: all tags).
    --timeout-multiplier multiply all timeout values with this constant.
    --timings            add timing information about the tests to the report.
    --trace              enable tracing using the strace unix shell command.
    --verbose            set verbosity level.
",
						       },
						      ],
				     description => "help message",
				    },
				   ],
	    description => "neurospaces_harness help and usage information",
	    name => '70_harness/10_help.t',
	   };

return $test;


