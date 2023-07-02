#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => '../bin/workflow builtin start_project workflow-tests',
				command_tests => [
						  {
						   description => "Can we start a new project ?",
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
						  },
						 ],
				description => "start of a new project",
			       },
			       {
				command => 'find .',
				command_tests => [
						  {
						   description => "Have the project files been created ?",
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
./docker
./docker/docker-build.bash
./docker/docker-run.bash
./docker/Dockerfile.neurospaces-testing
./workflow-tests-commands
',
						  },
						 ],
				description => "correct creation of the field project file",
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
				command => 'mv --verbose workflow-project-template.pl workflow-project.pl',
				command_tests => [
						  {
						   description => "Have the project files been created ?",
						   read => 'renamed \'workflow-project-template.pl\' -> \'workflow-project.pl\'
',
						  },
						 ],
				description => "rename the field project file to its final name",
			       },
			       {
				command => '../bin/workflow --help-field-project-name',
				command_tests => [
						  {
						   description => "Has the project been correctly initialized ?",
						   disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
								? ''
								: "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
						   read => '
global_field_project_configuration:
  field_project_configuration_filename: workflow-project.pl
  field_project_name: workflow-tests
  from_directory: .
  from_executable: workflow on the command line
  technical_project_configuration_directory: .
  true_technical_project_configuration_directory: /home/hugo/projects/developer/source/snapshots/master/tmp
  true_technical_project_configuration_filename: /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-project.pl
  true_technical_project_data_commands_directory: /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-commands-data
  true_technical_project_data_configuration_directory: /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-configuration-data
',
						  },
						 ],
				description => "correct creation of the field project file",
			       },
			       {
				command => '../bin/workflow builtin install_scripts -- --engine --commands',
				command_tests => [
						  {
						   comment => "The workflow engine emits its output about commands to be executed before executing those commnands, a wait clause in this test is required as a work around between the test engine and the workflow engine under test.",
						   description => "Have the project files been correctly installed ?",
						   disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
								? ''
								: "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
						   read => '# mkdir --parents /home/hugo/bin
#
# ln -sf /usr/local/bin/workflow /home/hugo/bin/workflow-tests-workflow
#
# ln -sf /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-configuration /home/hugo/bin/./workflow-tests-configuration
#
# ln -sf /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-commands /home/hugo/bin/./workflow-tests-commands
#
# bash -c "echo \'# workflow-tests-workflow

alias workflow-tests-workflow=\"grc workflow-tests-workflow\"
alias workflow-tests-configuration=\"grc workflow-tests-configuration\"
\' | cat >>/home/hugo/.bashrc"
#
# bash -c "echo \'. /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-bash-completion.sh
\' | cat >>/home/hugo/.bashrc"
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
# sudo     ln -sf /home/hugo/projects/developer/source/snapshots/master/tmp/conf.workflow-tests-configuration /usr/share/grc/conf.workflow-tests-configuration
#
# sudo     ln -sf /home/hugo/projects/developer/source/snapshots/master/tmp/conf.workflow-tests-workflow /usr/share/grc/conf.workflow-tests-workflow
#
',
						   wait => 0.1,
						  },
						 ],
				description => "correct installation of the new project files",
			       },
			       {
				command => 'workflow-tests-workflow --help-commands',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed ?",
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
						  },
						 ],
				description => "correct installation of the new project commands",
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
			       },
			       {
				command => 'workflow-tests-workflow examples_sh sh_single_command --dry-run',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed ?",
						   read => '/home/hugo/bin/workflow-tests-workflow: *** Running in dry_run 1 mode, not executing: \'/home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-commands-data/examples_sh/sh_single_command.sh\'
',
						  },
						 ],
				description => 'are the shell command templates installed and executed, --dry-run ?',
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
			       },
			       {
				command => 'workflow-tests-workflow examples_sh sh_single_command',
				command_tests => [
						  {
						   description => "Have the project specific commands been correctly installed ?",
						   read => '# /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						  },
						 ],
				description => 'are the shell command templates installed and executed ?',
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
			       },
			       {
				arguments => [
					      '-c',
					      "cd .. && workflow-tests-workflow examples_sh sh_single_command",
					     ],
				command => 'bash',
				command_tests => [
						  {
						   comment => "This test is the same as the previous one except for the cd command.",
						   description => "Have the project specific commands been correctly installed and are they executed when invoked from a different directory ?",
						   read => '# /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-commands-data/examples_sh/sh_single_command.sh
#
an example of the invocation of a single command
',
						  },
						 ],
				description => 'are the shell command templates installed and executed from a different directory?',
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
			       },
			       {
				arguments => [
					      'builtin',
					      'add_target',
					      '--',
					      'new_target',
					      "Add commands to this new target that do new things",
					      '--install-commands-sh',
					     ],
				command => 'workflow-tests-workflow',
				command_tests => [
						  {
						   description => "Can we add a new target and a template for new shell commands for this target?",
						   wait => 1,
						   read => 'workflow-tests-workflow: added target new_target to /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-configuration-data/targets.yml
workflow-tests-workflow: created the shell command file for target new_target',
						  },
						 ],
				description => 'can we add new targets with a shell template file for their commands ?',
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
			       },
			       {
				arguments => [
					      'builtin',
					      'add_target',
					      '--',
					      'new_target2',
					      "Add commands to this new target2 that do new things2",
					      '--install-commands-sh',
					     ],
				command => 'workflow-tests-workflow',
				command_tests => [
						  {
						   description => "Can we add a new target and a template for new shell commands for this target2?",
						   wait => 1,
						   read => {
							    application_output_file => './workflow-tests-configuration-data/targets.yml',
							    comment => "note that the '../' is required because the preparation clause switches to the './tmp' directory",
							    expected_output_file => "../$::global_config->{tests_directory}/strings/two-targets-added.txt",
							   },
						   read_not_used => 'workflow-tests-workflow: added target new_target2 to /home/hugo/projects/developer/source/snapshots/master/tmp/workflow-tests-configuration-data/targets.yml
workflow-tests-workflow: created the shell command file for target new_target2',
						  },
						 ],
				description => 'can we add new targets2 with a shell template file for their commands ?',
				disabled => ($ENV{PWD} eq '/home/hugo/projects/developer/source/snapshots/master'
					     ? ''
					     : "the currenct directory must be '/home/hugo/projects/developer/source/snapshots/master' to enable this test"),
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
				      description => "create the Docker image and create and enter the directory for running the tests",
				      preparer =>
				      sub
				      {
					  system "rm -fr tmp";
					  system "mkdir --parents tmp/docker";

					  system "cp -a tests/specifications/40_workflow-automator/Dockerfile.neurospaces-testing tmp/docker";
					  system "cp -a tests/specifications/40_workflow-automator/docker-build.bash tmp/docker";
					  system "cp -a tests/specifications/40_workflow-automator/docker-run.bash tmp/docker";

					  chdir "tmp";

					  system "cp -a ~/.bashrc ~/.bashrc-preparation";
					  system "sudo cp -a /etc/grc.conf /etc/grc.conf-preparation";

					  chdir "docker";

					  system "./docker-build.bash";

					  chdir "..";

					  # return no errors

					  return '';
				      },
				     },
		      reparation => {
				     description => "leave the directory for running the tests",
				     reparer =>
				     sub
				     {
					 system "rm ~/bin/workflow-tests*";

					 # system "sed -i '\$d' ~/.bashrc";
					 # system "sed -i '\$d' ~/.bashrc";
					 # system "sed -i '\$d' ~/.bashrc";
					 # system "sed -i '\$d' ~/.bashrc";
					 # system "sed -i '\$d' ~/.bashrc";
					 # system "sed -i '\$d' ~/.bashrc";

					 system "cp -a ~/.bashrc ~/.bashrc-reparation";
					 system "sudo cp -a /etc/grc.conf /etc/grc.conf-reparation";

					 system "cp -a ~/.bashrc-preparation ~/.bashrc";
					 system "sudo cp -a /etc/grc.conf-preparation /etc/grc.conf";

					 system "ls -1 /usr/share/grc/*test*";
					 system "sudo rm /usr/share/grc/conf.workflow-tests-configuration";
					 system "ls -1 /usr/share/grc/*test*";
					 system "sudo rm /usr/share/grc/conf.workflow-tests-workflow";
					 system "ls -1 /usr/share/grc/*test*";

					 chdir "..";
					 # system "rm -fr tmp";

					 # return no errors

					 return '';
				     },
				    },
		     },
       name => '40_workflow-automator/20_new-project.t',
      };


return $test;


