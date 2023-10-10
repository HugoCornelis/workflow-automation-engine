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
    --check-test-names           check the pathnames of the specification files against the names of the tests.
    --debugging                  enable specific debugging options.
    --dump-json                  dump test specifications to json files in /tmp/.
    --dump-perl                  dump test specifications to perl files in /tmp/.
    --dump-yaml                  dump test specifications to yaml files in /tmp/.
    --email                      allow to send emails, the default is taken from \$ENV{NEUROSPACES_HARNESS_OPTION_EMAIL}.
    --flattenout                 flattenout the test definitions before testing,
                                 this experimental feature might increase test performance,
                                 by recycling test definitions.
    --help                       print usage information.
    --numerical-compare          attempt to compare numbers numerically when string differences are found (default enabled).
    --output                     the class that should generate the output (default is 'Heterarch::Test::Executor').
    --output-content-line-limit  maximum number of lines when generating content output (latex, html, pdf).
    --output-figures             generate figures for test output with a figure clause.
    --output-html                generate HTML output.
    --output-latex               generate Latex output.
    --output-levels              generate output for these levels (default is 'meta, module, command_definition, command_test'.
    --output-pdf                 generate PDF output.
    --randomize-order            randomize the order of the tests before executing them (require List::Util to be installed).
    --regex-selector             defines a regex to run specific tests.
    --report-disabled            include information of disabled tests in the test report.
    --show                       show tests that would be run using the current configuration.
    --show-command-tests         show all the command definitions that would be run during test execution, including the input to those commands.
    --tags                       only test test modules that have been tagged with these tags (default: all tags).
    --timeout-multiplier         multiply all timeout values with this constant.
    --timings                    add timing information about the tests to the report.
    --trace                      enable tracing using the strace unix shell command.
    --verbose                    set verbosity level.
",
						       },
						      ],
				     description => "help message",
				    },
				   ],
	    description => "neurospaces_harness tester help and usage information",
	    documentation => {
			      explanation => "

The Neurospaces Harness automates unit, regression, integration and
smoke testing.  Declarative test specifications define application
behaviour and can be executed to validate application behaviour
against its specifications.

Command line options support extraction of documentation at various
levels of detail or for specific application functions.  Test
specifications can be converted either to a list of commands with test
input or to HTML or Latex to create a comprehensive series of manuals.

Used this way test specifications are an application knowledge base
that guarantee correct application behaviour.

",
			      purpose => "Help page.",
			     },
	    name => '70_harness/10_help.t',
	   };

return $test;


