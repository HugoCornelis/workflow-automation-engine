#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       description => "The system shall support Ethernet communication.",
       documentation => {
                         explanation => "
Ethernet communication is an ubiquitous standard and is useful for compatibility with other devices.
",

                         purpose => "Compatibility with other devices.",
			},
       name => 'high-level.t',
      };


return $test;


