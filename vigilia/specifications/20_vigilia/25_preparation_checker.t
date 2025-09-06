#!/usr/bin/perl -w
#

use strict;


my $test = {
	    command_definitions => [
				   ],
	    comment => "preparation and reparation tests",
	    description => "preparation checker module",
	    harnessing => {
			   preparation => {
					   description => "test the file that was created in the preparation clause of the previous test",
					   preparer =>
					   sub
					   {
					       use IO::File;

					       my $file = IO::File->new("/tmp/preparation.txt");

					       if (not $file)
					       {
						   die "$0: Cannot open file /tmp/preparation.txt";
					       }

					       my $text = <$file>;

					       if (
						   $text ne 'The preparation code has run
'
						  )
					       {
						   die "$0: The text in /tmp/preparation.txt is not what was expected.";
					       }
					   },
					  },
			   reparation => {
					  description => "test the file that was created in the reparation clause of the previous test",
					  reparer =>
					  sub
					  {
					      system "echo >/tmp/reparation.txt The reparation code has run";

					      use IO::File;

					      my $file = IO::File->new("/tmp/reparation.txt");

					      if (not $file)
					      {
						  die "$0: Cannot open file /tmp/reparation.txt";
					      }

					      my $text = <$file>;

					      if (
						  $text ne 'The reparation code has run
'
						 )
					      {
						  die "$0: The text in /tmp/reparation.txt is not what was expected.";
					      }
					  },
					 },
			   },
	    documentation => {
			      explanation => "

Specific clauses in these specifications are used to prepare and
restore the test environment prior to test execution.

This test module and the previous test module are jointly used to test
the correct execution of such clauses by the test harness.

",
			      purpose => "Custom preparation and restoration of the test environment.",
			     },
	    name => '20_vigilia/25_preparation_checker.t',
	   };

return $test;


