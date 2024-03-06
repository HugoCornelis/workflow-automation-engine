#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => '../bin/workflow --help',
				command_tests => [
						  {
						   description => "Do we get the main help page ?",
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
						  },
						 ],
				description => "the main help page",
			       },
			       {
				command => '../bin/workflow --help-commands',
				command_tests => [
						  {
						   comment => 'note that the expect module does not easily allow the read string to be started with yaml\'s \'---\'',
						   description => "Do we get the builtin commands help page ?",
						   read => '
\'available_commands (copy-paste the one you would like to execute, try it with the --help or the --dry-run option, or execute it without these options)\':
  - workflow builtin add_target --help
  - workflow builtin archive_configuration --help
  - workflow builtin install_scripts --help
  - workflow builtin print_configuration_directory --help
  - workflow builtin start_project --help
',
						  },
						 ],
				description => "default builtin commands",
			       },
			       {
				command => '../bin/workflow --help-targets',
				command_tests => [
						  {
						   comment => 'note that the expect module does not easily allow the read string to be started with yaml\'s \'---\'',
						   description => "Do we get the builtin targets help page ?",
						   read => '
targets:
  builtin:
    description: the builtin target allows to start a new project and upgrade existing projects
',
						  },
						 ],
				description => "default builtin targets",
			       },
			       {
				command => '../bin/workflow builtin start_project --help',
				command_tests => [
						  {
						   description => "Do we see the help page for starting a new project ?",
						   read => 'workflow builtin start_project: start a new project with a given name in the current directory.

This will install a project descriptor, a configuration file and an
empty command file.

arguments:

    name: name of the new project.
',
						  },
						 ],
				description => "default builtin targets",
			       },
			       {
				command => '../bin/workflow builtin add_target --help',
				command_tests => [
						  {
						   description => "Do we see the help page for adding a new target to a project ?",
						   read => 'workflow builtin add_target: add a new target and update the configuration to integrate it.

synopsis:

builtin add_target <target-name> <target-description> [-- <options>]

arguments:

    ARGV[0]: name of the new target.
    ARGV[1]: description of the new target.

options:

    --install-commands-pl: install a perl command file template.
    --install-commands-sh: install a shell command file template.

',
						  },
						 ],
				description => "default builtin targets",
			       },
			       {
				command => '../bin/workflow builtin archive_configuration --help',
				command_tests => [
						  {
						   description => "Do we see the help page for archiving a workflow configuration ?",
						   read => 'workflow builtin archive_configuration: create a tarball with the configuration of the current workflow project.

synopsis:

builtin archive_configuration <tarball-name>

arguments:

    ARGV[0]: name of the tarball.  Recognized filename extensions are \'tar.gz\', \'tar.bz2\', \'.tgz\' and \'.tbz\'.

',
						  },
						 ],
				description => "default builtin targets",
			       },
			      ],
       description => "help pages",
       documentation => {
			 explanation => "

The workflow script enables the automation of customizable modular
project-specific workflows that use system shell commands.

",
			 purpose => "This module tests the help pages of the workflow automation engine.",
			},
       harnessing => {
		      preparation => {
				      description => "create and enter the directory for running the tests",
				      preparer =>
				      sub
				      {
					  system "rm -fr tmp";
					  system "mkdir tmp";
					  chdir "tmp";

					  # return no errors

					  return '';
				      },
				     },
		      reparation => {
				     description => "leave and remove the directory for running the tests",
				     reparer =>
				     sub
				     {
					 chdir "..";
					 # system "rm -fr tmp";

					 # return no errors

					 return '';
				     },
				    },
		     },
       name => '40_workflow-automator/10_help-pages.t',
      };


return $test;


