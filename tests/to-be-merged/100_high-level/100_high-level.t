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

       # The test configuration ensures that only this test module
       # definition is found by pointing to only the directory that
       # has this definition.  As a consequence the name of the module
       # consists of the filename only.

       name => '100_high-level.t',
      };


return $test;


