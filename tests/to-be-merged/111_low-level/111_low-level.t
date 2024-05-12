#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       undef,
			       {
				command => 'netstat -rn',
				command_tests => [
						  {
						   comment => "The test assumes that the presence of a default gateway means a valid connect to the Internet is present.  The test waits for one second to ensure that the produced output is not truncated.",
						   description => "Is a route to the Internet available?",
						   read => "0.0.0.0",
						   wait => 1,
						  },
						 ],
				description => "find a route to the Internet",
			       },
			      ],
       name => 'low-level.t',
      };


return $test;


