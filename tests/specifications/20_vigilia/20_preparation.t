#!/usr/bin/perl -w
#

use strict;


my $test = {
	    command_definitions => [
				   ],
	    comment => "preparation and reparation tests",
	    description => "preparation module",
	    harnessing => {
			   preparation => {
					   description => "create a file that will be tested in the reparation clause and in the next test",
					   preparer =>
					   sub
					   {
					       system "echo >/tmp/preparation.txt The preparation code has run";
					   },
					  },
			   reparation => {
					  description => "checks whether the preparation clause has run and has created a file that will be tested in the next test",
					  reparer =>
					  sub
					  {
					      system "bash -c \"cat /tmp/preparation.txt | diff - <(echo 'The preparation code has run')\"";

					      system "echo >/tmp/reparation.txt The reparation code has run";
					  },
					 },
			  },
	    documentation => {
			      explanation => "

The Neurospaces Harness automates unit, regression, integration and
smoke testing.  Declarative test specifications define application
behaviour and are used to execute tests.

Specific clauses in these specifications are used to prepare and
restore the test environment prior to test execution.

This test module and the next test module are jointly used to test the
correct execution of such clauses by the test harness.

",
			      purpose => "Custom preparation and restoration of the test environment.",
			     },
	    name => '20_vigilia/20_preparation.t',
	   };

return $test;


