#!/usr/bin/perl -w
#

use strict;


my $test
    = {
#       disabled => 'the docker image needs additional packages.  Enter the docker image with "sudo docker exec -it neurospaces_harness bash"',
       command_definitions => [
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'pwd',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Are we in the correct working directory in the Docker container ?",
						   read => '/home/neurospaces
',
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						   white_space1 => 'convert seen \\x0d \\x0a to \\x0a newlines',
						  },
						 ],
				description => "showing that the container works: working directory",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'ls',
					      '-1',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we list the current directory in the Docker container ?",
						   read => 'projects
',
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: current directory contents",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd projects/developer/source/snapshots/master/ && ./autogen.sh',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can generate configure scripts in the Docker container ?",
						   wait => 1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: generation of configure scripts",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd projects/developer/source/snapshots/master/ && ./configure',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we configure the developer package in the Docker container ?",
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
checking for a thread-safe mkdir -p... /bin/mkdir -p
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
checking for python script directory... ${prefix}/lib/python3.9/site-packages
checking for python extension module directory... ${exec_prefix}/lib/python3.9/site-packages
checking Python prefix is ... \'${prefix}\'
find: \'tests/data\': No such file or directory
checking that generated files are newer than configure... done
configure: creating ./config.status
config.status: creating Makefile
config.status: creating perl/Makefile
config.status: creating python/Makefile
',
						   timeout => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: configuration of the developer package",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd projects/developer/source/snapshots/master/ && make',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we build the developer package in the Docker container ?",
						   read => 'Making all in perl
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
',
						   timeout => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: build of the developer package",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd projects/developer/source/snapshots/master/ && sudo make install',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we install the developer package in the Docker container ?",
						   read => 'Making install in perl
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
 /usr/bin/install -c bin/neurospaces_status bin/neurospaces_sync bin/neurospaces_tags bin/neurospaces_tools_propagate bin/neurospaces_uninstall bin/neurospaces_update bin/neurospaces_upgrade bin/neurospaces_versions bin/neurospaces_website_prepare bin/nspkg-deb bin/nspkg-osx bin/nspkg-rpm bin/nstest_query bin/numerical_compare bin/release-expand bin/release-extract bin/signal_voltage_characteristics bin/td-labels bin/td-majors bin/workflow \'/usr/local/bin\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/40_workflow-automator\'
 /usr/bin/install -c -m 644  tests/specifications/40_workflow-automator/20_new-project.t tests/specifications/40_workflow-automator/25_new-project-docker.t tests/specifications/40_workflow-automator/10_help-pages.t \'/usr/local/neurospaces/developer/tests/specifications/40_workflow-automator\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests\'
 /usr/bin/install -c -m 644  tests/introduction.html \'/usr/local/neurospaces/developer/tests\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/strings\'
 /usr/bin/install -c -m 644  tests/specifications/strings/neurospaces_build--no-compile--no-configure--no-install--regex-developer--dry-run--developer--verbose--verbose--verbose.txt tests/specifications/strings/two-targets-added.txt tests/specifications/strings/neurospaces_build--tag-build-10--no-compile--no-configure--no-install--regex-developer--dry-run--developer--verbose--verbose--verbose.txt \'/usr/local/neurospaces/developer/tests/specifications/strings\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/70_harness\'
 /usr/bin/install -c -m 644  tests/specifications/70_harness/70_preparation.t tests/specifications/70_harness/75_preparation_checker.t tests/specifications/70_harness/10_help.t \'/usr/local/neurospaces/developer/tests/specifications/70_harness\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications\'
 /usr/bin/install -c -m 644  tests/specifications/50_downloads.t tests/specifications/10_global.t tests/specifications/30_developer.t \'/usr/local/neurospaces/developer/tests/specifications\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/90_yaml\'
 /usr/bin/install -c -m 644  tests/specifications/90_yaml/50_downloads.t tests/specifications/90_yaml/10_global.t tests/specifications/90_yaml/30_developer.t \'/usr/local/neurospaces/developer/tests/specifications/90_yaml\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/91_json/70_harness\'
 /usr/bin/install -c -m 644  tests/specifications/91_json/70_harness/70_preparation.t tests/specifications/91_json/70_harness/75_preparation_checker.t tests/specifications/91_json/70_harness/10_help.t \'/usr/local/neurospaces/developer/tests/specifications/91_json/70_harness\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/91_json\'
 /usr/bin/install -c -m 644  tests/specifications/91_json/50_downloads.t tests/specifications/91_json/10_global.t tests/specifications/91_json/30_developer.t \'/usr/local/neurospaces/developer/tests/specifications/91_json\'
 /bin/mkdir -p \'/usr/local/neurospaces/developer/tests/specifications/90_yaml/70_harness\'
 /usr/bin/install -c -m 644  tests/specifications/90_yaml/70_harness/70_preparation.t tests/specifications/90_yaml/70_harness/75_preparation_checker.t tests/specifications/90_yaml/70_harness/10_help.t \'/usr/local/neurospaces/developer/tests/specifications/90_yaml/70_harness\'
make[2]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
make[1]: Leaving directory \'/home/neurospaces/projects/developer/source/snapshots/master\'
',
						   timeout => 5,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: installation of the developer package",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'workflow --help',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we get the help page of the workflow engine in the Docker container ?",
						   read => '
/usr/local/bin/workflow: support for workflow design for embedded software engineers.

SYNOPSIS

/usr/local/bin/workflow <options> <target> <command> -- < ... command specific options and arguments ... >

EXAMPLES -- first try these with the --dry-run to understand what they do:

  $ /usr/local/bin/workflow ssp build                                            # \'build\' the \'ssp\' target (if it exists for your local configuration).

  $ /usr/local/bin/workflow --dry-run ssp build                                  # display the shell commands that would be executed to \'build\' the \'ssp\' target.

  $ /usr/local/bin/workflow --help-targets                                       # display the available targets that are found in the configuration file.

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
				description => "showing that the container works: help page of the workflow engine",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'mkdir workflow-test && cd workflow-test && workflow builtin start_project workflow-tests',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we start a new project in the Docker container ?",
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
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: start of a new project",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd workflow-test && find .',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Have the project files been created inside the Docker container?",
						   read => '.
./workflow-project-template.pl
./workflow-tests-bash-completion.sh
./workflow-tests-configuration-data
./workflow-tests-configuration-data/targets.yml
./workflow-tests-configuration-data/command_filenames.yml
./workflow-tests-configuration-data/target_servers.yml
./workflow-tests-configuration-data/build_servers.yml
./workflow-tests-configuration-data/node_configuration.yml
./conf.workflow-tests-workflow
./conf.workflow-tests-configuration
./workflow-tests-commands-data
./workflow-tests-commands-data/examples_sh
./workflow-tests-commands-data/examples_sh/sh_array_of_commands.sh
./workflow-tests-commands-data/examples_sh/sh_single_command.sh
./workflow-tests-commands-data/examples_sh/sh_remote_execution.sh
./workflow-tests-commands-data/examples_yml
./workflow-tests-commands-data/examples_yml/remote_execution.yml
./workflow-tests-commands-data/examples_yml/array_of_commands.yml
./workflow-tests-commands-data/examples_yml/single_command.yml
./workflow-tests-configuration
./workflow-tests-commands
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: correct creation of the field project file",
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
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd workflow-test && mv --verbose workflow-project-template.pl workflow-project.pl',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we rename the project configuration files to activate the project inside the container ?",
						   read => 'renamed \'workflow-project-template.pl\' -> \'workflow-project.pl\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: rename the field project file to its final name",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd workflow-test && workflow --help-field-project-name',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Has the project been correctly initialized inside the container?",
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
				description => "showing that the container works: correct creation of the field project file",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd workflow-test && workflow builtin install_scripts -- --engine --commands',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   comment => "The workflow engine emits its output about commands to be executed before executing those commnands, a wait clause in this test is required as a work around between the test engine and the workflow engine under test.",
						   description => "Have the project files been correctly installed inside the container ?",
						   read => '# ln -sf /usr/local/bin/workflow /home/neurospaces/bin/workflow-tests-workflow
#
# ln -sf /home/neurospaces/workflow-test/workflow-tests-configuration /home/neurospaces/bin/./workflow-tests-configuration
#
# ln -sf /home/neurospaces/workflow-test/workflow-tests-commands /home/neurospaces/bin/./workflow-tests-commands
#
# bash -c "echo \'# workflow-tests-workflow

alias workflow-tests-workflow=\"grc workflow-tests-workflow\"
alias workflow-tests-configuration=\"grc workflow-tests-configuration\"
\' | cat >>/home/neurospaces/.bashrc"
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
						   wait => 0.1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: correct installation of the new project files",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'echo "export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/neurospaces/bin" >~/.bashrc',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we update .bashrc to make sure that the project specific workflow engine is found inside the container ?",
						   wait => 0.1,
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => "showing that the container works: update .bashrc to make sure that the project specific workflow engine is found",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'cd workflow-test && workflow-tests-workflow --help-commands',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed inside the container ?",
						   read => '
\'available_commands (copy-paste the one you would like to execute, try it with the --help or the --dry-run option, or execute it without these options)\':
  - workflow-tests-workflow builtin add_target --help
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
				description => "showing that the container works: correct installation of the new project commands",
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'workflow-tests-workflow examples_sh sh_single_command --dry-run',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed inside the container ?",
						   read => '/home/neurospaces/bin/workflow-tests-workflow: *** Running in dry_run 1 mode, not executing: \'/home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh\'
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'showing that the container works: are the shell command templates installed and executed, --dry-run ?',
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'workflow-tests-workflow examples_sh sh_single_command',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed inside the container ?",
						   read => '# /home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'showing that the container works: are the shell command templates installed and executed ?',
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      "cd .. && workflow-tests-workflow examples_sh sh_single_command",
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   comment => "This test is the same as the previous one except for the cd command.",
						   description => "Have the project specific commands been correctly installed and are they executed when invoked from a different directory, inside the container ?",
						   read => '# /home/neurospaces/workflow-test/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'showing that the container works: are the shell command templates installed and executed from a different directory?',
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'workflow-tests-workflow builtin add_target -- new_target "Add commands to this new target that do new things" --install-commands-sh',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we add a new target and a template for new shell commands for this target inside the container ?",
						   wait => 1,
						   read => 'workflow-tests-workflow: added target new_target to /home/neurospaces/workflow-test/workflow-tests-configuration-data/targets.yml
workflow-tests-workflow: created the shell command file for target new_target',
						   white_space => 'convert seen 0a to 0d 0a newlines',
						  },
						 ],
				description => 'showing that the container works: can we add new targets with a shell template file for their commands ?',
			       },
			       {
				arguments => [
					      'docker',
					      'exec',
					      '-it',
					      'neurospaces_harness',
					      'bash',
					      '-ic',
					      'workflow-tests-workflow builtin add_target -- new_target2 "Add commands to this new target2 that do new things2" --install-commands-sh',
					     ],
				command => 'sudo',
				command_tests => [
						  {
						   description => "Can we add a new target and a template for new shell commands for this target2, inside the container ?",
						   disabled => "we cannot read an output file inside the container yet, but this tests wants to check for it",
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
				description => 'showing that the container works: can we add new targets2 with a shell template file for their commands ?',
			       },
			      ],
       description => "testing of the workflow automation engine",
       documentation => {
			 explanation => "

The workflow script enables the automation of customizable modular
project-specific workflows that use shell commands.

",
			 purpose => "This module tests the workflow automation engine.",
			},
       harnessing => {
		      preparation => {
				      description => "create the Docker image and start it as a container for running the tests",
				      preparer =>
				      sub
				      {
					  system "./tests/specifications/40_workflow-automator/docker-build.bash";

					  system "sudo docker container stop neurospaces_harness";
					  system "sudo docker container rm neurospaces_harness";

					  system "sudo docker run -d -t --name neurospaces_harness neurospaces_image";

					  # return no errors

					  return '';
				      },
				     },
		      reparation => {
				     description => "leave the directory for running the tests",
				     reparer =>
				     sub
				     {
					 # return no errors

					 return '';
				     },
				    },
		     },
       name => '40_workflow-automator/25_new-project-docker.t',
      };


return $test;


