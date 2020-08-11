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
	    name => '70_harness/70_preparation.t',
	   };

return $test;


