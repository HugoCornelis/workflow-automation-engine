#!/usr/bin/perl -w
#

use strict;


my $test = {
	    command_definitions => [
				    {
				     command => 'pwd',
				     command_tests => [
						       {
							description => "Are we in the correct working directory in the Docker container ?",
							read => '/home/neurospaces
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: working directory",
				    },
				    {
				     command => 'cd projects/developer/source/snapshots/master && tar xfz cpan/02-Mo-0.40.tar.gz && cd Mo-0.40 && perl Makefile.PL && make && sudo make install',
				     command_tests => [
						       {
							comment => 'perl installation seems to be non-deterministic, only checking a part of the output',
							description => "Can we install the Mo cpan module ?",
							read => 'Installing /usr/local/bin/mo-inline
Appending installation info to /usr/local/lib/x86_64-linux-gnu/perl/5.32.1/perllocal.pod
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "cpan installation of Mo",
				    },
				    {
				     command => 'cd projects/developer/source/snapshots/master && tar xfz cpan/13-Data-Utilities-0.04.tar.gz && cd Data-Utilities-0.04 && perl Makefile.PL && make && sudo make install',
				     command_tests => [
						       {
							comment => 'perl installation seems to be non-deterministic, only checking a part of the output',
							description => "Can we install the Data::Utilities cpan module ?",
							read => 'Manifying 4 pod documents
Manifying 4 pod documents
Installing /usr/local/share/perl/5.32.1/Data/Merger.pm
Installing /usr/local/share/perl/5.32.1/Data/Differences.pm
Installing /usr/local/share/perl/5.32.1/Data/Comparator.pm
Installing /usr/local/share/perl/5.32.1/Data/Utilities.pm
Installing /usr/local/share/perl/5.32.1/Data/Transformator.pm
Installing /usr/local/man/man3/Data::Comparator.3pm
Installing /usr/local/man/man3/Data::Merger.3pm
Installing /usr/local/man/man3/Data::Transformator.3pm
Installing /usr/local/man/man3/Data::Utilities.3pm
Appending installation info to /usr/local/lib/x86_64-linux-gnu/perl/5.32.1/perllocal.pod
',
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "cpan installation of Data::Utilities",
				    },
				    {
				     command => 'cd projects/developer/source/snapshots/master && ./configure && make && sudo make install',
				     command_tests => [
						       {
							description => "Can we list the working directory in the Docker container ?",
							read => 'checking build system type... x86_64-pc-linux-gnu
checking host system type... x86_64-pc-linux-gnu
checking target system type... x86_64-pc-linux-gnu
checking whether we build universal binaries.... no
checking OS specifics...... Host is running linux-gnu.
checking for perl5... no
checking for perl... perl
checking Checking the perl module installation path...  ${prefix}/share/perl/5.32.1 
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking for mtn... no
checking for monotone... no
checking for dpkg-buildpackage... dpkg-buildpackage
checking for dh... no
checking for rpmbuild... no
checking for python... no
checking for python2... no
checking for python3... /usr/bin/python3
checking for python version... 3.9
checking for python platform... linux
checking for GNU default python prefix... ${prefix}
checking for GNU default python exec_prefix... ${exec_prefix}
checking for python script directory (pythondir)... ${PYTHON_PREFIX}/lib/python3.9/site-packages
checking for python extension module directory (pyexecdir)... ${PYTHON_EXEC_PREFIX}/lib/python3.9/site-packages
checking Python prefix is ... \'${prefix}\'
find: \'tests/data\': No such file or directory
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating perl/Makefile
config.status: creating python/Makefile
Making all in perl
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
make[1]: Nothing to be done for \'all\'.
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
Making all in python
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
echo "No need to build in python"
No need to build in python
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
make[1]: Nothing to be done for \'all-am\'.
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
Making install in perl
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
make[2]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
make[2]: Nothing to be done for \'install-exec-am\'.
 /bin/mkdir -p \'/usr/local/share/perl/5.32.1\'
 /bin/mkdir -p \'/usr/local/share/perl/5.32.1/Neurospaces/Developer\'
 /usr/bin/install -c -m 644  ./Neurospaces/Developer/Operations.pm ./Neurospaces/Developer/Packages.pm \'/usr/local/share/perl/5.32.1/Neurospaces/Developer\'
 /bin/mkdir -p \'/usr/local/share/perl/5.32.1/Neurospaces/Developer/Manager\'
 /usr/bin/install -c -m 644  ./Neurospaces/Developer/Manager/GUI.pm \'/usr/local/share/perl/5.32.1/Neurospaces/Developer/Manager\'
 /bin/mkdir -p \'/usr/local/share/perl/5.32.1/Neurospaces\'
 /usr/bin/install -c -m 644  ./Neurospaces/Tester.pm ./Neurospaces/Developer.pm \'/usr/local/share/perl/5.32.1/Neurospaces\'
make[2]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/perl\'
Making install in python
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make[2]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make  install-exec-hook
make[3]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
echo "No install"
No install
make[3]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make[2]: Nothing to be done for \'install-data-am\'.
make[2]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master/python\'
make[1]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
make[2]: Entering directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
 /bin/mkdir -p \'/usr/local/bin\'
 /usr/bin/install -c bin/data_2_figure bin/mcad2doxy bin/mtn-ancestors bin/neurospaces-commands bin/neurospaces-manager-gui bin/neurospaces_build bin/neurospaces_check bin/neurospaces_clean bin/neurospaces_clone bin/neurospaces_configure bin/neurospaces_countcode bin/neurospaces_create_directories bin/neurospaces_cron bin/neurospaces_describe bin/neurospaces_dev_uninstall bin/neurospaces_diff bin/neurospaces_dist bin/neurospaces_docs bin/neurospaces_docs-level7 bin/neurospaces_harness bin/neurospaces_harness_2_html bin/neurospaces_history bin/neurospaces_init bin/neurospaces_install bin/neurospaces_kill_servers bin/neurospaces_migrate bin/neurospaces_mtn_2_git bin/neurospaces_new_component bin/neurospaces_packages bin/neurospaces_pkgdeb bin/neurospaces_pkgrpm bin/neurospaces_pkgtar bin/neurospaces_profile_set bin/neurospaces_pull bin/neurospaces_push bin/neurospaces_repo_keys bin/neurospaces_repositories bin/neurospaces_revert bin/neurospaces_serve bin/neurospaces_setup \'/usr/local/bin\'
 /usr/bin/install -c bin/neurospaces_status bin/neurospaces_sync bin/neurospaces_tags bin/neurospaces_tools_propagate bin/neurospaces_uninstall bin/neurospaces_update bin/neurospaces_upgrade bin/neurospaces_versions bin/neurospaces_website_prepare bin/nspkg-deb bin/nspkg-osx bin/nspkg-rpm bin/nstest_query bin/numerical_compare bin/release-expand bin/release-extract bin/signal_voltage_characteristics bin/td-labels bin/td-majors \'/usr/local/bin\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer\'
',
							timeout => 5,
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "showing that the container works: working directory contents",
				    },
				    {
				     command => 'cd projects/developer/source/snapshots/master && neurospaces_harness --show',
				     command_tests => [
						       {
							description => "Can we inspect the commands that will be run during the tests ?",
							read => "
description:
  command: /usr/local/bin/neurospaces_harness
  name: Test report
  package:
    name: developer
    version: alpha
selected:
  10_global.t:
    - description: help message
      tests:
        - Is a help message given ?
    - description: no options
      tests:
        - Is an error message given when invoking the build script without options ?
    - description: help message
      tests:
        - Can we set environment variables ?
    - description: wrong options
      tests:
        - Is an error message given when invoking the build script with wrong options ?
  30_developer.t: []
  50_downloads.t: []
  70_harness/10_help.t:
    - description: help message
      tests:
        - Is a help message given ?
  70_harness/20_preparation.t: []
  70_harness/25_preparation_checker.t: []
  70_harness/30_docker.t:
    - description: 'showing that the container works: working directory'
      tests:
        - Are we in the correct working directory in the Docker container ?
    - description: 'showing that the container works: working directory contents'
      tests:
        - Can we list the working directory in the Docker container ?
    - description: 'showing that the container works: root directory contents'
      tests:
        - Can we list the root directory in the Docker container ?
  70_harness/40_output_formats.t:
    - description: 'showing that the container works: working directory'
      tests:
        - Are we in the correct working directory in the Docker container ?
    - description: cpan installation of Mo
      tests:
        - Can we install the Mo cpan module ?
    - description: cpan installation of Data::Utilities
      tests:
        - Can we install the Data::Utilities cpan module ?
    - description: 'showing that the container works: working directory contents'
      tests:
        - Can we list the working directory in the Docker container ?
    - description: inspecting the commands that are tested
      tests:
        - Can we inspect the commands that will be run during the tests ?
  90_yaml/10_global.t:
    - description: help message
      tests:
        - Is a help message given ?
    - description: no options
      tests:
        - Is an error message given when invoking the build script without options ?
    - description: help message
      tests:
        - Can we set environment variables ?
    - description: wrong options
      tests:
        - Is an error message given when invoking the build script with wrong options ?
  90_yaml/30_developer.t:
    - description: 'operate on the developer package, without any compiling and related, verbose dry run mode'
      tests:
        - 'Can we operate on the developer package, without any compiling and related, verbose dry run mode ?'
  90_yaml/50_downloads.t: []
  90_yaml/70_harness/10_help.t:
    - description: help message
      tests:
        - Is a help message given ?
  90_yaml/70_harness/70_preparation.t: []
  90_yaml/70_harness/75_preparation_checker.t: []
  91_json/10_global.t:
    - description: help message
      tests:
        - Is a help message given ?
    - description: no options
      tests:
        - Is an error message given when invoking the build script without options ?
    - description: help message
      tests:
        - Can we set environment variables ?
    - description: wrong options
      tests:
        - Is an error message given when invoking the build script with wrong options ?
  91_json/30_developer.t:
    - description: 'operate on the developer package, without any compiling and related, verbose dry run mode'
      tests:
        - 'Can we operate on the developer package, without any compiling and related, verbose dry run mode ?'
  91_json/50_downloads.t: []

*** Info: See '>/tmp/report_developer.yml' for the detailed report
No email sent.
/usr/local/bin/neurospaces_harness: 0 error(s)
",
							white_space => 'convert seen 0a to 0d 0a newlines',
						       },
						      ],
				     description => "inspecting the commands that are tested",
				    },
				   ],
	    comment => "docker harness tests",
	    description => "docker harness test module",
	    harnessing => {
			   class => {
				     build => "./tests/specifications/dockerfiles/neurospaces-harness-docker-build.bash",
				     comment => 'Enter this container with "docker exec -it neurospaces_harness_test_container bash"',
				     default_user => 'neurospaces',
				     identifier => 'docker_based_harness',
				     name_container => 'neurospaces_harness_test_container',
				     name_image => 'neurospaces_harness_test_image',
				     type => '',
				    },
			  },
	    documentation => {
			      explanation => "

The Neurospaces Harness automates unit, regression, integration and
smoke testing.  Declarative test specifications define application
behaviour and are used to execute tests.

Specific clauses in these specifications are used to prepare and
restore the test environment prior to test execution.

This test module tests the different output formatters that allow to
convert test specifications to documentation.

",
			      purpose => "Docker test environment.",
			     },
	    name => '70_harness/40_output_formats.t',
	   };

return $test;


