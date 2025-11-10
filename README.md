![Logos](logos/cables-bw-final-comp-1-shrunk-cropped-reduced-bottom-640x170.png)

# Introduction

`workflow` and `vigilia` offer features that allow guaranteeing a
single “source of truth” for the documentation of a software system.

The `workflow` engine helps automating complicated system shell tasks
during the development of a software project.

The `vigilia` tester uses a database of test specifications to
generate documentation of user-visible functions and validate if the
delivered software complies with the required application functions.


__The Workflow Automation Engine__

The workflow engine helps automating complicated system shell tasks
during the development of a software project.

Typical examples of workflow automation are running local and remote
shell commands with arguments and options that are hard to remember,
to compile source code on a build server, to convert documentation to
a web page, to flash a binary software image such as the Linux kernel
to a small or embedded device, or orchestrate the execution of command
sequences on different local, remote and virtual machines.

The workflow engine offers the following functions:

- Convenient implmenetation of modular custom workflows, with or
  without arguments, including bash completions and help pages.
- Easy to start a new project, new _targets_ and new _commands_.
- Integration with `bash` completion allows browsing project specific
  _targets_, project specific _commands_ and project specific
  _configuration_.
- Integration with `grc` for project specific _keyword highlighting_.
- Support for different _roles_ e.g. for remote execution, in a Docker
  container or in a `tmux` session.

__The `vigilia` tester__

The `vigilia` tester starts from a declarative database of test
specifications to:

- Run the tests and report about software application behaviour.
- Query the test specifications as a knowledge base of implemented,
  required or desired application function.
- Separate layers of test specfications.
- Generate documentation of user-visible functions.
- Isolate a test environment through virtualization.


## Abstract

Software documentation management systems face three long-standing
challenges: (1) Consistent software documentation synchronization with
system function, (2) Satisfy industry certification schemes, (3)
Document workflows required for project execution, collaboration
between software developers and reduce on-boarding time of new
developers.

Two complimentary software applications are introduced: `workflow` and
`vigilia`.  Together, they elaborate a multipolar view of the
implementation of a software documentation project while allowing
refinement during project development.

`workflow` automates the technical workflows required for project
development.  Its descriptions are based on system shell commands
through a set of configuration files.

Separation of project specific workflow configurations supports
collaboration between software developers through a shared git
repository.

The configuration files implement, automate, track and document the
execution of a series of system shell commands across machines used
for multi-role compilations, builds, tests and deployment.

A tester tool, `vigilia` isolates declarative test descriptions from
their execution.

These descriptions facilitate layering of the documentation levels
required for industry compliance and certification.

Specific features of test descriptions can be tagged for inclusion in
documents derived from the tests.

Combining these features guarantees a single “source of truth”
ensuring software system tests, documents and software functions
remain coherently synchronized.


# Installation

## Prerequisites

`workflow` and `vigilia` require [YAML](https://yaml.org/),
[JSON](https://toml.io/en/) or [TOML](https://toml.io/en/) for
configuration files.  The Perl modules `File::chdir`, and
`File::Find::Rule`, the Perl module for integration of Python code
into Perl are required[^1].  `workflow` uses `grc` for colorification
of its output.  Installation itself is performed with `autotools` and
`make` and uses `gcc` to compile C code.

As an example, for Ubuntu 22.04.3 LTS jammy, you need to install these
prerequisites:

```
sudo apt install automake
sudo apt install grc
sudo apt install libfile-chdir-perl
sudo apt install libinline-python-perl
sudo apt install libjson-perl
sudo apt install libtoml-perl
sudo apt install libyaml-perl
sudo apt install make
sudo apt libfile-find-rule-perl
sudo apt libnet-ip-perl
sudo apt libexpect-perl
```

[^1]: The Perl module that integrates with Python is called Inline::Python.  This module currently has a bug that generates warnings when multiple Python source code files are inlined.  A fix is available from https://github.com/niner/inline-python-pm but this fix is not available from package managers yet.

Then clone this repository into a local directory:

```
git clone https://github.com/HugoCornelis/workflow-automation-engine.git
cd workflow-automation-engine
```

## Installation

Generate a `configure` script with the command:

```
./autogen.sh
```

Install `workflow` and `vigilia` using `configure` and `make`:

```
./configure
make
sudo make install
```

`workflow` and `vigilia` are now installed on your system.



# Using `workflow` and `vigilia`

## Starting a new `workflow` project

Starting a new `workflow` project with name *foo* consists of these
steps:

1. `workflow builtin start_project foo`

	Creates a workflow configuration for a new project with name
    *foo* and initialize a `git` repository for it.

2. `workflow builtin install_scripts -- --commands --git`

	Makes the configuration available from any directory.

3. `foo-workflow --help-commands`

	Optionally shows the available commands for the project with name
    *foo*.

4. `foo-workflow examples_sh sh_single_command`

	By default the workflow engine installs a few commands that you
    can easily adapt to your needs.  This is one of them.  Use the
    `--dry-run` option to see exactly what commands would be executed,
    use the `--interactions` option to see the same commands based on
    the role which would execute them.

5. `foo-workflow builtin add_target -- bar "Add commands to this new target that do new things" --install-commands-sh`

	Adds the target *bar* and creates a directory with a few template
    examples for you to adapt to your project.


## Starting a new `vigilia` project

Starting a new `vigilia` project with name *bar* consists of these
steps:

1. `vigilia configuration-create bar alpha`

2. `vigilia module-create 100_test_module`

3. `vigilia command-add 100_test_module a_tested_command "This test tests 'a_tested_command' and expects the output it currently generates`

This section is incomplete.


