# The Workflow Automation Engine

The workflow automation engine helps automating complicated system
shell tasks during the development of a software project.

Typical examples of workflow automation are shell commands to compile
source code on a build server or convert documentation to a web page
where these commands take arguments and options that are hard to
remember.

Other examples are commands to flash a binary image such as the Linux
kernel to a small or embedded device.

## Overview

The workflow automation engine offers the following functions:

- Easy to start a new project, new _targets_ and new _commands_.
- Integration with `bash` completion allows browsing project specific
  _targets_, project specific _commands_ and project specific
  _configuration_.
- Integration with `grc` for project specific _keyword highlighting_.
- Support for different _roles_ that allows remote execution, in a
  Docker container or a `tmux` session.

## Installation

### Prerequisites

### Installation from a Tarball

This will install the latest available release that was considered
'stable' by the developer team.  It can be downloaded from:

https://github.com/HugoCornelis/workflow-automation-engine/raw/master/workflow-automation-0.1.0-alpha.tar.gz


## Starting a new project

Starting a new workflow project with name *abcd* consists of these
steps:

1. `workflow builtin start_project abcd`

	Creates a workflow configuration for a new project with name
    *abcd*.

2. `mv workflow-project-template.pl workflow-project.pl`

	Renames the template project file such that the workflow engine
	recognizes it.

3. `workflow builtin install_scripts -- --engine --commands --git`

	Makes the configuration available from any directory.

4. `abcd-workflow --help-commands`

	Optionally shows the available commands for the project with name
    *abcd*.

5. `abcd-workflow examples_sh sh_single_command`

	By default the workflow engine installs a few commands that you
    can easily adapt to your needs.  This is one of them.  Use the
    `--dry-run` option to see exactly what commands would be executed,
    use the `--interactions` option to see the same commands based on
    the role which would execute them.

6. `abcd-workflow builtin add_target -- xyz "Add commands to this new target that do new things" --install-commands-sh`

	Adds the target *xyz* and creates a directory with a few template
    examples for you to adapt to your project.

