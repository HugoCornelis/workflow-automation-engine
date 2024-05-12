#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'ifconfig',
				command_tests => [
						  {
						   comment => "The test assumes that the word 'ether' is followed with an MAC address and provides evidence that an Ethernet device is available.  To ensure that all the output is visible the test waits for one second after the tested command is executed.",
						   description => "Do we find an Ethernet compatible device?",
						   read => "ether ",
						   wait => 1,
						  },
						 ],
				description => "find an Ethernet compatible device",
			       },
			      ],
       name => 'mid-level.t',
      };


return $test;


