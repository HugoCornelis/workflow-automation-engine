
# The Workflow Automation Configuration for feature-testing

The workflow automation engine helps automating complicated system
shell tasks during the development of a software project.

The scripts in this directory provide the workflow automation
configuration for the feature-testing project.


## Overview

The workflow automation engine offers the following functions:

- Easy to start a new _project_, and add new _targets_ and new
  _commands_ to a project.
- Integration with `bash` completion allows exploring and browsing
  project specific _targets_, project specific _commands_ and project
  specific _configuration_.
- Integration with `grc` for project specific _keyword highlighting_.
- The use of different _roles_ allows remote execution of commands
  over an ssh session, in a Docker container or a `tmux` session.
- Modular construction of complex worfklow that combine several
  features of the workflow engine.

## Installation

To use this configuration, install the workflow automation engine
and its prerequisites by following the instructions available at:

https://github.com/HugoCornelis/workflow-automation-engine/blob/master/README.md

Typical prerequisites are `grc`, `yaml` related libraries and
developer tools such as `automake`.

After installation of the workflow engine, use the following command
from this directory to make this project configuration available to
the workflow engine:

`$ workflow builtin configuration_install -- --commands --aliasses --bash-completion`

The output of the command explains what has been done and it is
recommended to carefully inspect it.  The help page of the command
explains:

```
$ workflow builtin configuration_install --help
workflow builtin configuration_install : install or upgrade the workflow scripts for this project.

options:

    --aliasses         configure the grc aliases in .bashrc if they are not there yet.
    --bash-completion  configure bash completion in .bashrc if they are not there yet.
    --commands         install or upgrade the command configuration to ~/bin.
    --path-in-bashrc   update .bashrc to include ~/bin in PATH.

Note that grc configuration files will also be installed and configured.
```

The installation of the `grc` configuration files requires `sudo`
access to be configured.


## Use

If you used one of the `--bash-completion` or `--path-in-bashrc`
options during the installation of the workflow scripts, execute your
`.bashrc` or login with a new shell to ensure that `bash` is
configured with the new completions and paths.

Afterwards a good starting point for using the configuration is:

```
$ feature-testing-workflow --help-commands
```
Then followed with one of the `--dry-run` and `--interactions` options
applied to one of the shown commands to understand what these commands would do
if executed without options:

```
<fill in your project specific examples here>
```

You are ready to use this configuration.  Don't forget to use bash
completion to explore the available targets and commands.
