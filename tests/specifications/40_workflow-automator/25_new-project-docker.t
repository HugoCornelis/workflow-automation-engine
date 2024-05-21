#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'pwd',
				command_tests => [
						  {
						   description => "Are we in the correct working directory?",
						   read => '/home/neurospaces
',
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						   white_space1 => 'convert seen \\x0d \\x0a to \\x0a newlines',
						  },
						 ],
				command_user => 'neurospaces',
				description => "working directory",
			       },
			       {
				command => 'ls -1',
				command_tests => [
						  {
						   description => "Can we list the current directory?",
						   read => 'projects
',
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "current directory contents",
			       },
			       {
				command => 'cd projects/workflow-automation-engine/source/snapshots/master/ && ./autogen.sh',
				command_tests => [
						  {
						   description => "Can we generate configure scripts?",
						   tags => [ 'manual' ],
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "generating configure scripts",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd projects/workflow-automation-engine/source/snapshots/master/ && ./configure',
				command_tests => [
						  {
						   description => "Can we configure the workflow automation engine source code?",
						   read => 'checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a race-free mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make supports nested variables... yes
checking whether we build universal binaries.... no
checking OS specifics...... Host is running .
checking for perl5... no
checking for perl... perl
checking Checking the perl module installation path...  ${prefix}/share/perl/5.36.0 
./configure: line 2663: cd: perl: No such file or directory
./configure: line 2666: cd: perl: No such file or directory
checking for mtn... no
checking for monotone... no
checking for dpkg-buildpackage... dpkg-buildpackage
checking for dh... no
checking for rpmbuild... no
checking for python... no
checking for python2... no
checking for python3... /usr/bin/python3
checking for python version... 3.11
checking for python platform... linux
checking for GNU default python prefix... ${prefix}
checking for GNU default python exec_prefix... ${exec_prefix}
checking for python script directory (pythondir)... ${PYTHON_PREFIX}/lib/python3.11/site-packages
checking for python extension module directory (pyexecdir)... ${PYTHON_EXEC_PREFIX}/lib/python3.11/site-packages
checking Python prefix is ... \'${prefix}\'
find: \'tests/data\': No such file or directory
checking that generated files are newer than configure... done
: creating ./config.status
config.status: creating Makefile
',
						   tags => [ 'manual' ],
						   timeout => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "configuring the source code",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd projects/workflow-automation-engine/source/snapshots/master/ && make',
				command_tests => [
						  {
						   description => "Can we build the workflow automation engine?",
						   read => 'make[1]: Entering directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
make[1]: Nothing to be done for \'all-am\'.
make[1]: Leaving directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
',
						   tags => [ 'manual' ],
						   timeout => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "building the workflow automation engine",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd projects/workflow-automation-engine/source/snapshots/master/ && sudo make install',
				command_tests => [
						  {
						   description => "Can we install the workflow automation engine?",
						   read => "make[1]: Entering directory '/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master'
make[2]: Entering directory '/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master'
 /usr/bin/mkdir -p '/usr/local/bin'
 /usr/bin/install -c bin/workflow '/usr/local/bin'
make[2]: Nothing to be done for 'install-data-am'.
make[2]: Leaving directory '/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master'
make[1]: Leaving directory '/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master'
",
						   read_old => 'make[1]: Entering directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
make[2]: Entering directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
 /usr/bin/mkdir -p \'/usr/local/bin\'
 /usr/bin/install -c bin/workflow \'/usr/local/bin\'
======================== Installing CPAN modules
( cd cpan ; ./cpan_install [0-9][0-9]*.gz )
Installing CPAN modules
$VAR1 = [
          \'13-Data-Utilities-0.04.tar.gz\'
        ];
checking for perl -e \'use Data::Utilities 0.04\'
Can\'t locate Data/Utilities.pm in @INC (you may need to install the Data::Utilities module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.36.0 /usr/local/share/perl/5.36.0 /usr/lib/x86_64-linux-gnu/perl5/5.36 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.36 /usr/share/perl/5.36 /usr/local/lib/site_perl) at -e line 1.
BEGIN failed--compilation aborted at -e line 1.
Installing Data-Utilities-0.04 (13-Data-Utilities-0.04.tar.gz)
/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan
/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan/Data-Utilities-0.04
Checking if your kit is complete...
Looks good
Generating a Unix-style Makefile
Writing Makefile for Data::Utilities
Writing MYMETA.yml and MYMETA.json
make[3]: Entering directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan/Data-Utilities-0.04\'
',
# cp lib/Data/.*
# cp lib/Data/.*
# cp lib/Data/.*
# cp lib/Data/.*
# cp lib/Data/.*
# Manifying 4 pod documents
# make[3]: Leaving directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan/Data-Utilities-0.04\'
# make[3]: Entering directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan/Data-Utilities-0.04\'
# PERL_DL_NONLAZY=1 "/usr/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, \'blib/lib\', \'blib/arch\')" t/*.t
# t/0.t ............ t/0.t ............ 1/2                         t/0.t ............ ok
# t/001_load.t ..... t/001_load.t ..... 1/1                         t/001_load.t ..... ok
# t/1.t ............ t/1.t ............ 1/?                          t/1.t ............ ok
# t/array1.t ....... t/array1.t ....... 1/6                         t/array1.t ....... ok
# t/comparator1.t .. t/comparator1.t .. 1/9                         t/comparator1.t .. ok
# t/merger1.t ...... t/merger1.t ...... 1/9                         t/merger1.t ...... ok
# t/merger2.t ...... t/merger2.t ...... 1/10                           t/merger2.t ...... ok
# All tests successful.
# Files=.*
# Result: PASS
# make[3]: Leaving directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master/cpan/Data-Utilities-0.04\'
# Manifying 4 pod documents
# Installing /usr/local/share/perl/5.36.0/Data/Merger.pm
# Installing /usr/local/share/perl/5.36.0/Data/Differences.pm
# Installing /usr/local/share/perl/5.36.0/Data/Comparator.pm
# Installing /usr/local/share/perl/5.36.0/Data/Utilities.pm
# Installing /usr/local/share/perl/5.36.0/Data/Transformator.pm
# Installing /usr/local/man/man3/Data::Comparator.3pm
# Installing /usr/local/man/man3/Data::Merger.3pm
# Installing /usr/local/man/man3/Data::Transformator.3pm
# Installing /usr/local/man/man3/Data::Utilities.3pm
# Appending installation info to /usr/local/lib/x86_64-linux-gnu/perl/5.36.0/perllocal.pod
# touch ./neurospaces_cpan_modules
# make[2]: Leaving directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
# make[1]: Leaving directory \'/home/neurospaces/projects/workflow-automation-engine/source/snapshots/master\'
# ',
						   tags => [ 'manual' ],
						   wait => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "installating the workflow automation engine",
				tags => [ 'manual' ],
			       },
			       {
				command => 'workflow --help',
				command_tests => [
						  {
						   description => "Can we get the help page?",
						   read => '
workflow: support for workflow design for embedded software engineers.

SYNOPSIS

workflow <options> <target> <command> -- < ... command specific options and arguments ... >

EXAMPLES -- first try these with the --dry-run to understand what they do:

  $ workflow --help-targets                                       # display the available targets that are found in the configuration file.

  $ workflow --help-commands                                      # display the available commands that are found in the configuration file.

  $ workflow ssp build                                            # \'build\' the \'ssp\' target (if it exists for your local configuration).

  $ workflow --dry-run ssp build                                  # display the shell commands that would be executed to \'build\' the \'ssp\' target.

options:
    --bash-completion               compute bash completion for the given command line.
                                    hint: the bash completion script implements completion for options, targets and commands.
    --branch                        git branch to work with.
    --build-server                  the build server profile to work with.
    --built-image-directory         the directory on the build server where the built images are to be found.
    --command                       commands to execute, hyphens (-) in the command will be replaced with underscores (_).
    --dry-run                       if set, do not execute system shell commands but print them to STDOUT.
    --dump-all-interaction-roles    dump all the interaction roles found in the configuration.
    --dump-interaction-roles        dump the found interaction roles (note that they depend on the scheduled commands).
    --dump-module-interaction-roles dump all the interaction roles found in the module of the given command.
    --dump-schedule                 dump the constructed schedule to standard output without executing the scheduled commands.
    --export-remote                 include the remote access part of exported commands.
                                    this option takes a number: 0 means all roles are exported, any other number exports only that respective role.
    --export-sh                     export the commands to a file with the given name.
    --export-sudo                   include the sudo commands when exporting commands to a file.
    --export-times                  export the times when commands are started and ended to a file with the given name.
    --export-verbose                when exporting the commands to a file, interleave them with echo commands.
    --force-rebuild                 force a rebuild regardless of the existence and build date of previously built artefacts.
    --forward-destination           the target file forward destination to copy to.
    --forward-source                the target file forward source to copy from.
    --help                          display usage information and stop execution.
    --help-build-servers            display the known build servers.
    --help-commands                 display the available commands, add a target name for restricted output.
    --help-module                   display all the available help information about the commands of the module.
    --help-field-project-name       print the field project name and exit.
    --help-options                  print the option values.
    --help-packages                 display known package and overriden package information and stop execution.
    --help-projects                 display known project information and stop execution.
    --help-targets                  display known targets and stop execution.
    --incremental                   assume an incremental build (default is yes
    --interactions                  show the interaction diagram of the commands.
    --interactions-all              show a diagram with all the commands and all the interaction roles.
    --interactions-module           show the interaction diagram of all the commands in the module.
    --interactions-module-all-roles show the interaction diagram of the commands using all the found interaction roles in the configuration.
    --packages                      packages to operate on, can be given multiple times.
    --ssh-port                      the ssh port.
    --ssh-server                    the used ssh build server.
    --ssh-user                      ssh-user on the build server (please configure your public key).
    --target                        the target to apply the given commands to.
    --tftp-directory                the target tftp directory (eg. where your device will find its kernel and rootfs).
    --verbose                       set verbosity level.

NOTES

OVERRIDE_SRCDIR delivered packages for Buildroot targets are recognized.

',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "help page of the workflow engine",
			       },
			       {
				command => 'mkdir workflow-test && cd workflow-test && workflow builtin start_project workflow-tests',
				command_tests => [
						  {
						   description => "Can we start a new project?",
						   read => 'Using \'workflow-tests\' as name for your project.
Created a template configuration file for project \'workflow-tests\'
Created a template workflow-project in \'workflow-project-template.pl\' with contents:
---
#!/usr/bin/perl -w

use strict;

use warnings;

my $configuration
    = {
       field_project_name => \'workflow-tests\',
      };

return $configuration;

---
If this looks good, please rename it to \'workflow-project.pl\' using the command:

  mv \'workflow-project-template.pl\' \'workflow-project.pl\'

And test it with the command:

  workflow --help-field-project-name

Afterwards install the scripts on your system using the command:

  workflow builtin install_scripts -- --engine --commands --git

Then check if they work by inspecting the examples they provide (with various options):

  workflow-tests-workflow examples array_of_commands_remote_execution --interactions

  workflow-tests-workflow examples sequencing_and_composition --interactions-module

  workflow-tests-workflow examples single_command --dry-run

  workflow-tests-workflow examples array_of_commands --help
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "starting a new project",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd workflow-test && find . | sort',
				command_tests => [
						  {
						   description => "Have the project files been created?",
						   read => '.
./conf.workflow-tests-configuration
./conf.workflow-tests-workflow
./workflow-project-template.pl
./workflow-tests-bash-completion.sh
./workflow-tests-commands
./workflow-tests-commands-data
./workflow-tests-commands-data/examples_sh
./workflow-tests-commands-data/examples_sh/sh_array_of_commands.sh
./workflow-tests-commands-data/examples_sh/sh_remote_execution.sh
./workflow-tests-commands-data/examples_sh/sh_single_command.sh
./workflow-tests-commands-data/examples_yml
./workflow-tests-commands-data/examples_yml/array_of_commands.yml
./workflow-tests-commands-data/examples_yml/remote_execution.yml
./workflow-tests-commands-data/examples_yml/single_command.yml
./workflow-tests-configuration
./workflow-tests-configuration-data
./workflow-tests-configuration-data/build_servers.yml
./workflow-tests-configuration-data/command_filenames.yml
./workflow-tests-configuration-data/node_configuration.yml
./workflow-tests-configuration-data/target_servers.yml
./workflow-tests-configuration-data/targets.yml
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "creation of the field project file",
			       },
			       {
				command_notused => 'test -x workflow-tests-commands-data/examples_sh/sh_single_command.sh',
				command =>
				sub
				{
				    if (-x "workflow-tests-commands-data/examples_sh/sh_single_command.sh")
				    {
					return undef;
				    }
				    else
				    {
					return "workflow-tests-commands-data/examples_sh/sh_single_command.sh does not have its execute bit set"
				    }
				},
				description => "check the execute bit of the generated shell scripts",
				disabled => 'must be adapted for the Docker container',
			       },
			       # {
			       # 	class => "Heterarch::Test::CommandDefinition::IsFileExecutable",
			       # 	arguments => {
			       # 		      error => "workflow-tests-commands-data/examples_sh/sh_single_command.sh does not have its execute bit set",
			       # 		      filename => "workflow-tests-commands-data/examples_sh/sh_single_command.sh",
			       # 		     },
			       # 	description => "check the execute bit of the generated shell scripts",
			       # },
			       {
				command => 'cd workflow-test && mv --verbose workflow-project-template.pl workflow-project.pl',
				command_tests => [
						  {
						   description => "Can we rename the project configuration files to activate the project?",
						   read => 'renamed \'workflow-project-template.pl\' -> \'workflow-project.pl\'
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "rename the field project file to its final name",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd workflow-test && workflow --help-field-project-name',
				command_tests => [
						  {
						   description => "Has the project been correctly initialized?",
						   read => '
global_field_project_configuration:
  field_project_configuration_filename: workflow-project.pl
  field_project_name: workflow-tests
  from_directory: .
  from_executable: workflow on the command line
  technical_project_configuration_directory: .
  true_technical_project_configuration_directory: /home/neurospaces/workflow-test
  true_technical_project_configuration_filename: /home/neurospaces/workflow-test/workflow-project.pl
  true_technical_project_data_commands_directory: /home/neurospaces/workflow-test/workflow-tests-commands-data
  true_technical_project_data_configuration_directory: /home/neurospaces/workflow-test/workflow-tests-configuration-data
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct creation of the field project file",
			       },
			       {
				command => 'cd workflow-test && workflow builtin install_scripts -- --no-aliasses --engine --commands',
				command_tests => [
						  {
						   comment => "The workflow engine emits its output about commands to be executed before executing those commnands, a wait clause in this test is required to ensure that the the workflow engine has executed the commands after it has reported that it will execute them.",
						   description => "Can we install the project files?",
						   read => '# mkdir --parents /home/neurospaces/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/workflow-tests-workflow
#
# ln -sf /home/neurospaces/workflow-test/workflow-tests-configuration /home/neurospaces/bin/./workflow-tests-configuration
#
# ln -sf /home/neurospaces/workflow-test/workflow-tests-commands /home/neurospaces/bin/./workflow-tests-commands
#
# bash -c "echo \'. /home/neurospaces/workflow-test/workflow-tests-bash-completion.sh
\' | cat >>/home/neurospaces/.bashrc"
#
# sudo     bash -c "echo \'
# workflow-tests-workflow
(^|[/\w\.]+/)workflow-tests-workflow\s?
conf.workflow-tests-workflow

# workflow-tests-configuration
(^|[/\w\.]+/)workflow-tests-configuration\s?
conf.workflow-tests-configuration

\' | cat >>/etc/grc.conf"
#
# sudo     ln -sf /home/neurospaces/workflow-test/conf.workflow-tests-configuration /usr/share/grc/conf.workflow-tests-configuration
#
# sudo     ln -sf /home/neurospaces/workflow-test/conf.workflow-tests-workflow /usr/share/grc/conf.workflow-tests-workflow
#
',
						   tags => [ 'manual' ],
						   wait => 0.1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct installation of the new project files",
				tags => [ 'manual' ],
			       },
			       {
				command => 'echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/neurospaces/bin" >>~/.bashrc',
				command_tests => [
						  {
						   description => "Can we update .bashrc to make sure that the project specific version of the workflow engine is found?",
						   tags => [ 'manual' ],
						   wait => 0.1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "update .bashrc to make sure that the project specific version of the workflow engine is found",
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd workflow-test && workflow-tests-workflow --help-commands',
				command_tests => [
						  {
						   description => "Have the project workflows been correctly installed?",
						   read => '
\'available_commands (copy-paste the one you would like to execute, try it with the --help or the --dry-run option, or execute it without these options)\':
  - workflow-tests-workflow builtin add_target --help
  - workflow-tests-workflow builtin archive_configuration --help
  - workflow-tests-workflow builtin install_scripts --help
  - workflow-tests-workflow builtin print_configuration_directory --help
  - workflow-tests-workflow builtin start_project --help
  - workflow-tests-workflow examples array_of_commands --help
  - workflow-tests-workflow examples array_of_commands_remote_execution --help
  - workflow-tests-workflow examples sequencing_and_composition --help
  - workflow-tests-workflow examples single_command --help
  - workflow-tests-workflow examples_sh sh_array_of_commands --help
  - workflow-tests-workflow examples_sh sh_remote_execution --help
  - workflow-tests-workflow examples_sh sh_single_command --help
  - workflow-tests-workflow examples_yml array_of_commands --help
  - workflow-tests-workflow examples_yml remote_execution --help
  - workflow-tests-workflow examples_yml single_command --help
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct installation of the workflows of the new project",
			       },
			       {
				command => 'workflow-tests-workflow --help-commands',
				command_tests => [
						  {
						   description => "Have the project workflows been correctly installed, different working directory?",
						   read => '
\'available_commands (copy-paste the one you would like to execute, try it with the --help or the --dry-run option, or execute it without these options)\':
  - workflow-tests-workflow builtin add_target --help
  - workflow-tests-workflow builtin archive_configuration --help
  - workflow-tests-workflow builtin install_scripts --help
  - workflow-tests-workflow builtin print_configuration_directory --help
  - workflow-tests-workflow builtin start_project --help
  - workflow-tests-workflow examples array_of_commands --help
  - workflow-tests-workflow examples array_of_commands_remote_execution --help
  - workflow-tests-workflow examples sequencing_and_composition --help
  - workflow-tests-workflow examples single_command --help
  - workflow-tests-workflow examples_sh sh_array_of_commands --help
  - workflow-tests-workflow examples_sh sh_remote_execution --help
  - workflow-tests-workflow examples_sh sh_single_command --help
  - workflow-tests-workflow examples_yml array_of_commands --help
  - workflow-tests-workflow examples_yml remote_execution --help
  - workflow-tests-workflow examples_yml single_command --help
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "correct installation of the workflows of the new project",
				tags => [ 'manual' ],
			       },
			       {
				command => 'workflow-tests-workflow examples_sh sh_single_command --dry-run',
				command_tests => [
						  {
						   description => "Can we dry run one of the installed workflows to inspect which commands it would run?",
						   read => 'workflow-tests-workflow: *** Running in dry_run 1 mode, not executing: \'/home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'installation and execution of the workflows, --dry-run',
			       },
			       {
				command => 'workflow-tests-workflow examples_sh sh_single_command',
				command_tests => [
						  {
						   description => "Can we execute one of the installed workflows?",
						   read => '# /home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'installation and execution of the workflows, no dry run',
			       },
			       {
				command => "cd .. && workflow-tests-workflow examples_sh sh_single_command",
				command_tests => [
						  {
						   comment => "This test is the same as the previous one except for the cd command.",
						   description => "Have the project workflows been correctly installed and are they executed when invoked from a different directory?",
						   read => '# /home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'execution of the workflow templates from a different directory',
			       },
			       {
				command => 'workflow-tests-workflow builtin add_target -- new_target "Add commands to this new target that do new things" --install-commands-sh',
				command_tests => [
						  {
						   description => "Can we add a new target and workflow template?",
						   wait => 1,
						   read => 'workflow-tests-workflow: added target new_target to /home/neurospaces/workflow-test/workflow-tests-configuration-data/targets.yml
workflow-tests-workflow: created the shell command file for target new_target',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'adding new targets and workflow templates',
				tags => [ 'manual' ],
			       },
			       {
				command => 'workflow-tests-workflow builtin add_target -- new_target2 "Add commands to this new target2 that do new things2" --install-commands-sh',
				command_tests => [
						  {
						   description => "Can we add more targets and workflow templates?",
						   disabled => "we cannot read an output file inside the test container yet, but this tests wants to check for it",
						   wait => 1,
						   read => {
							    application_output_file => './workflow-tests-configuration-data/targets.yml',
							    # comment => "note that the '../' is required because the preparation clause switches to the './tmp' directory",
							    expected_output_file => "$::global_config->{tests_directory}/strings/two-targets-added.txt",
							   },
						   read_not_used => 'workflow-tests-workflow: added target new_target2 to /home/neurospaces/workflow-test/workflow-tests-configuration-data/targets.yml
workflow-tests-workflow: created the shell command file for target new_target2',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'adding more targets and workflow templates',
			       },
			       {
				command => 'workflow --help-projects',
				command_tests => [
						  {
						   description => "Can we list the known workflow projects using the regular workflow executable?",
						   read => '
available_workflow automation projects (copy-paste the one you would like to get help for):
  - workflow-tests-workflow --help-commands
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'listing the known workflow projects using the workflow executable',
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion" 1',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the options?",
						   read => 'bash-completion --branch --build-server --built-image-directory --command --dry-run --dump-all-interaction-roles --dump-interaction-roles --dump-module-interaction-roles --dump-schedule --export-remote --export-sh --export-sudo --export-times --export-verbose --force-rebuild --forward-destination --forward-source --help --help-build-servers --help-commands --help-field-project-name --help-module --help-options --help-packages --help-projects --help-targets --incremental --interactions --interactions-all --interactions-module --interactions-module-all-roles --packages --ssh-port --ssh-server --ssh-user --target --tftp-directory --verbose aa bb',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'generation of bash completion strings for the options',
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion " 0',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the targets?",
						   read => 'a --b builtin examples examples_sh examples_yml',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'generation of bash completion strings for the targets',
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion builtin " 2',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the commands?",
						   read => 'a --b add_target archive_configuration install_scripts print_configuration_directory start_project',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'generation of bash completion strings for the commands',
			       },
			       {
				command => 'workflow-tests-workflow --verbose builtin archive_configuration /tmp/wtw.tar.gz',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate an archive of the created configuration?",
						   read => 'Invoking (Command::builtin_archive_configuration)
---
global_field_project_configuration:
  field_project_name: workflow-tests
  from_executable: dynamically_generated from the executable script name
  technical_project_configuration_directory: /home/neurospaces/bin
  technical_project_configuration_filename: /home/neurospaces/bin/workflow-tests-configuration
  true_technical_project_configuration_directory: /home/neurospaces/workflow-test
  true_technical_project_configuration_filename: /home/neurospaces/workflow-test/workflow-tests-configuration
  true_technical_project_data_commands_directory: /home/neurospaces/workflow-test/workflow-tests-commands-data
  true_technical_project_data_configuration_directory: /home/neurospaces/workflow-test/workflow-tests-configuration-data
---
CWD: /home/neurospaces
scripts:
  - workflow-test/conf.workflow-tests-configuration
  - workflow-test/conf.workflow-tests-workflow
  - workflow-test/workflow-project.pl
  - workflow-test/workflow-tests-bash-completion.sh
  - workflow-test/workflow-tests-commands
  - workflow-test/workflow-tests-commands-data/examples_sh/sh_array_of_commands.sh
  - workflow-test/workflow-tests-commands-data/examples_sh/sh_remote_execution.sh
  - workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
  - workflow-test/workflow-tests-commands-data/examples_yml/array_of_commands.yml
  - workflow-test/workflow-tests-commands-data/examples_yml/remote_execution.yml
  - workflow-test/workflow-tests-commands-data/examples_yml/single_command.yml
  - workflow-test/workflow-tests-commands-data/new_target/sh_array_of_commands.sh
  - workflow-test/workflow-tests-commands-data/new_target/sh_remote_execution.sh
  - workflow-test/workflow-tests-commands-data/new_target/sh_single_command.sh
  - workflow-test/workflow-tests-configuration
  - workflow-test/workflow-tests-configuration-data/build_servers.yml
  - workflow-test/workflow-tests-configuration-data/command_filenames.yml
  - workflow-test/workflow-tests-configuration-data/node_configuration.yml
  - workflow-test/workflow-tests-configuration-data/target_servers.yml
  - workflow-test/workflow-tests-configuration-data/targets.yml
tar_filename: /tmp/wtw.tar.gz
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'creation of an archive of a configuration',
				tags => [ 'manual' ],
			       },
			       {
				command => 'tar tfz /tmp/wtw.tar.gz | sort',
				command_tests => [
						  {
						   description => "Can we inspect the archive of the configuration in the tarball?",
						   read => 'workflow-test/conf.workflow-tests-configuration
workflow-test/conf.workflow-tests-workflow
workflow-test/workflow-project.pl
workflow-test/workflow-tests-bash-completion.sh
workflow-test/workflow-tests-commands
workflow-test/workflow-tests-commands-data/examples_sh/sh_array_of_commands.sh
workflow-test/workflow-tests-commands-data/examples_sh/sh_remote_execution.sh
workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
workflow-test/workflow-tests-commands-data/examples_yml/array_of_commands.yml
workflow-test/workflow-tests-commands-data/examples_yml/remote_execution.yml
workflow-test/workflow-tests-commands-data/examples_yml/single_command.yml
workflow-test/workflow-tests-commands-data/new_target/sh_array_of_commands.sh
workflow-test/workflow-tests-commands-data/new_target/sh_remote_execution.sh
workflow-test/workflow-tests-commands-data/new_target/sh_single_command.sh
workflow-test/workflow-tests-configuration
workflow-test/workflow-tests-configuration-data/build_servers.yml
workflow-test/workflow-tests-configuration-data/command_filenames.yml
workflow-test/workflow-tests-configuration-data/node_configuration.yml
workflow-test/workflow-tests-configuration-data/target_servers.yml
workflow-test/workflow-tests-configuration-data/targets.yml
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'inspection of the generated archive',
			       },
			       {
				command => 'cd ~ && mkdir -vp ~/projects/workflow-configuration',
				command_tests => [
						  {
						   description => "Can we create the directories for installing an archived workflow configuration?",
						   read => 'mkdir: created directory \'/home/neurospaces2/projects\'
mkdir: created directory \'/home/neurospaces2/projects/workflow-configuration\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'preparation to install an archived workflow configuration',
			       },
			       {
				command => 'cd ~/projects/workflow-configuration && tar xvfz /tmp/wtw.tar.gz',
				command_tests => [
						  {
						   description => "Can we unpack an archived workflow configuration?",
						   read => 'workflow-test/conf.workflow-tests-configuration
workflow-test/conf.workflow-tests-workflow
workflow-test/workflow-project.pl
workflow-test/workflow-tests-bash-completion.sh
workflow-test/workflow-tests-commands
workflow-test/workflow-tests-commands-data/examples_sh/sh_array_of_commands.sh
workflow-test/workflow-tests-commands-data/examples_sh/sh_remote_execution.sh
workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
workflow-test/workflow-tests-commands-data/examples_yml/array_of_commands.yml
workflow-test/workflow-tests-commands-data/examples_yml/remote_execution.yml
workflow-test/workflow-tests-commands-data/examples_yml/single_command.yml
workflow-test/workflow-tests-commands-data/new_target/sh_array_of_commands.sh
workflow-test/workflow-tests-commands-data/new_target/sh_remote_execution.sh
workflow-test/workflow-tests-commands-data/new_target/sh_single_command.sh
workflow-test/workflow-tests-configuration
workflow-test/workflow-tests-configuration-data/build_servers.yml
workflow-test/workflow-tests-configuration-data/command_filenames.yml
workflow-test/workflow-tests-configuration-data/node_configuration.yml
workflow-test/workflow-tests-configuration-data/target_servers.yml
workflow-test/workflow-tests-configuration-data/targets.yml
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'unpacking an archived workflow configuration',
				tags => [ 'manual' ],
			       },
			       {
				command => 'cd ~/projects/workflow-configuration/workflow-test && workflow builtin install_scripts -- --engine --commands --path-in-bashrc --no-aliasses',
				command_tests => [
						  {
						   comment => "The aliasses are not installed in the bashrc script because the color coding introduced by 'grc' complicates testing.",
						   description => "Can we install an unpacked workflow configuration?",
						   read => '# bash -c "echo \'# necessary for $project_name-workflow

export PATH=\"$HOME/bin:$PATH\"

\' | cat >>/home/neurospaces2/.bashrc"
#
# mkdir --parents /home/neurospaces2/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces2/bin/workflow-tests-workflow
#
# ln -sf /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-configuration /home/neurospaces2/bin/./workflow-tests-configuration
#
# ln -sf /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-commands /home/neurospaces2/bin/./workflow-tests-commands
#
# bash -c "echo \'. /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-bash-completion.sh
\' | cat >>/home/neurospaces2/.bashrc"
#
',
						   read_with_aliasses => '# bash -c "echo \'# necessary for $project_name-workflow

export PATH=\"$HOME/bin:$PATH\"

\' | cat >>/home/neurospaces2/.bashrc"
#
# mkdir --parents /home/neurospaces2/bin
#
# ln -sf /usr/local/bin/workflow /home/neurospaces2/bin/workflow-tests-workflow
#
# ln -sf /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-configuration /home/neurospaces2/bin/./workflow-tests-configuration
#
# ln -sf /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-commands /home/neurospaces2/bin/./workflow-tests-commands
#
# bash -c "echo \'# workflow-tests-workflow

alias workflow-tests-workflow=\"grc workflow-tests-workflow\"
alias workflow-tests-configuration=\"grc workflow-tests-configuration\"
\' | cat >>/home/neurospaces2/.bashrc"
#
# bash -c "echo \'. /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-bash-completion.sh
\' | cat >>/home/neurospaces2/.bashrc"
#
',
						   tags => [ 'manual' ],
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'installing a  workflow configuration',
				tags => [ 'manual' ],
			       },
			       {
				command => 'workflow-tests-workflow builtin print_configuration_directory',
				command_tests => [
						  {
						   description => "Is the installed workflow configuration found and correct?",
						   read => '
global_field_project_configuration:
  field_project_name: workflow-tests
  from_executable: dynamically_generated from the executable script name
  technical_project_configuration_directory: /home/neurospaces2/bin
  technical_project_configuration_filename: /home/neurospaces2/bin/workflow-tests-configuration
  true_technical_project_configuration_directory: /home/neurospaces2/projects/workflow-configuration/workflow-test
  true_technical_project_configuration_filename: /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-configuration
  true_technical_project_data_commands_directory: /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-commands-data
  true_technical_project_data_configuration_directory: /home/neurospaces2/projects/workflow-configuration/workflow-test/workflow-tests-configuration-data
',
						   tags => [ 'manual' ],
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'testing an new installed workflow configuration',
				tags => [ 'manual' ],
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion" 1',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the options for the new installed configuration?",
						   read => 'bash-completion --branch --build-server --built-image-directory --command --dry-run --dump-all-interaction-roles --dump-interaction-roles --dump-module-interaction-roles --dump-schedule --export-remote --export-sh --export-sudo --export-times --export-verbose --force-rebuild --forward-destination --forward-source --help --help-build-servers --help-commands --help-field-project-name --help-module --help-options --help-packages --help-projects --help-targets --incremental --interactions --interactions-all --interactions-module --interactions-module-all-roles --packages --ssh-port --ssh-server --ssh-user --target --tftp-directory --verbose aa bb',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'generation of bash completion strings for the options for the new installed configuration',
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion " 0',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the targets for the new installed configuration?",
						   read => 'a --b builtin examples examples_sh examples_yml',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'generation of bash completion strings for the targets for the new installed configuration',
			       },
			       {
				command => 'workflow-tests-workflow --bash-completion "workflow-tests-workflow --bash-completion builtin " 2',
				command_tests => [
						  {
						   comment => "the expected output is missing the first two dashes that introduce the first option",
						   description => "Can we generate bash completion strings for the commands for the new installed configuration?",
						   read => 'a --b add_target archive_configuration install_scripts print_configuration_directory start_project',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				command_user => 'neurospaces2',
				description => 'generation of bash completion strings for the commands for the new installed configuration',
			       },
			      ],
       description => "testing the workflow automation engine",
       documentation => {
			 explanation => "

The workflow script enables the automation of customizable modular
project-specific workflows consisting of shell commands.

",
			 purpose => "This module tests the workflow automation engine.",
			},
       harnessing => {
		      class => {
				comment => 'Enter this container with "docker exec -it workflow_automation_test_container bash"',
				default_user => 'neurospaces',
				dockerfile => './tests/specifications/dockerfiles/Dockerfile.workflow',
				identifier => 'docker_based_harness',
				name_container => 'workflow_automation_test_container',
				name_image => 'workflow_automation_image',
				type => 'Heterarch::Test::ExecutionContext::Harness::Docker',
			       },
		     },
       name => '40_workflow-automator/25_new-project-docker.t',
       tags => [ 'manual' ],
      };


return $test;


