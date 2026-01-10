![Logos](logos/cables-bw-final-comp-1-shrunk-cropped-reduced-bottom-640x170.png)

# Introduction

`workflow` and `vigilia` provide features that ensure a single "source
of truth" for documenting software project and systems.

The `workflow` engine automates and documents complex shell-based
tasks in software development.  It addresses the problem of technical
debt by making project execution workflows persistent, reproducible,
and easier to maintain.

The `vigilia` framework uses a database of test specifications to
generate documentation for user-facing functionality and to verify
that the delivered software meets the required application functions.


## `workflow` Applications

`workflow` engine configurations, applications and libraries are
typically developed in Python and have a license that is indepent of
`workflow`.  They can consequently be commercialized as a bridge
between Open Source Software and closed source software if feasible.

`workflow` applications can fall into one of several categories:

- Simple project wrapper that allows a developer to quickly find the
  tools and command lines required to carry out a given project.
- Library or executable wrapper,
- Infrastructure maintenance tool,
- Software component system integration and inspection.

`workflow` generates developer-facing documentation For each of these
catories as required.


### Simple `workflow` Applications

A simple `workflow` application centralizes and documents the tools
and command-line workflows required to work effectively on a project.

The `workflow` configuration implements bash completion in a minimal
project wrapper to standardize access to project-specific tooling and
exposes the exact command-line interfaces required to build, test,
deploy, or otherwise operate the project.

A `git` repository for the configuration ensures that developers share
a common view on project execution.  The help pages of the workflows
are automatically collected in a manual per project stage.


### Library and Executable Wrappers

Typical `workflow` configuration examples of library and executable
wrappers include:

- Linux kernel testing and debugging: Compile a specific Linux kernel
  source tree and initiate debugging sessions under `qemu`.

- Yocto and Buildroot wrapping: Use the Yocto or Buildroot build
  systems more conveniently and leverage `workflow` `bash` completion
  to explore available `defconfig`s and recipes, and track which
  packages have already been built.  Advanced configuration allow
  starting `qemu` with a project specific Linux kernel and rootfs.


### Infrastructure Maintenance

Infrastructure maintenance requires both local and remote execution of
commands from different user accounts.

A `workflow` configuration implements the necessary roles to connect
to a local or remote service or software component and inspect or
alter its state with to a specific configuration.  Both workflows and
roles can be made available through bash completion.

Typical `workflow` configuration examples for IT infrastructure
maintenance include:

- System diagnosis: System specific integration of the tools such as
  `ps`, `top`, `lsof`, `ss`, `systemctl`, `docker ps` to understand
  why a given process or service is running or why a given port is
  bound.  This allows to cross layers of supervisors, containers and
  services to find the root cause of a specific problem.  This type of
  `worfklow` configuration explains why a process exists, rather than
  just that it exists.

- IT network and infrastructure administration: Automate the IT
  administration tasks such as monitoring remote machines and
  inspection of registration details of a device inside a Docker
  container.  The `workflow` configuration offers a conceptual
  operational view on a complex IT network while still allowing
  inspection and configuration of all the network details.


### Software Component Integration Systems

Combining and integrating the `workflow` functions for wrappers and
infrastructure maintenance opens the possibility for` configurations
for systems integration.  These applications are of a larger scale
than the other categories.  Typical examples include:

- Device fleet simulation: Build and compose embedded software
  artifacts together with supporting open-source components to
  simulate end-to-end device fleet behavior, including provisioning,
  orchestration, and failure scenarios.

  The configuration integrates the embedded software artifacts of a
  build system such as Yocto or Buildroot with open-source components,
  such as `qemu`, Grafana, Hawkbit and Guacamolee, required to
  simulate device fleet scenarios.

  In this case, the `workflow` engine is used as the system integrator
  rather than a simple automation script, for the integration of
  dozens of repositories, focusing on cross-component version
  compatibility and correct configuration matrices for multiple
  hardware variants.

- Continuous Integration and Continuous Delivery (CI/CD) system
  orchestration: A `workflow` configuration coordinates the automated
  building, testing, analysis, and deployment of software across
  multiple repositories, environments, and target platforms.  The
  configuration defines execution order, conditional logic,
  parallelization, and failure handling, and provides the tools for
  inspection and diagnosis at each stage and scale.  This helps
  ensuring that the CI/CD system becomes a central operational
  backbone that enforces consistency, reproducibility, and
  traceability across an organization’s software delivery lifecycle.


## `vigilia` Applications

`vigilia` was originally used as a first line documentation generation
system for the [GENESIS neural simulation
system](http://genesis-sim.org/):

- Unit, regression and integration testing: Starting `vigilia` from a
  `cron` job implements the execution of tests to catch error
  introduced by new development early.
- Static HTML web site generation: Specific test specifications model
  real use cases and form the basis for documentation writers to
  develop tutorial materials.
- Manual generation: The inline description of selected tests are
  converted to a PDF document that forms the foundation of
  specification and user manuals.


## Technical Details

### The Workflow Automation Engine

The `workflow` engine helps automate complex system shell tasks during
project execution.

The `workflow` engine provides the following capabilities:

- Convenient implementation of modular, custom workflows integrated
  with `bash` completion and automatically generated help pages.
- Simple creation of new projects, new _targets_, and new _commands_.
- Integration with Bash completion enables browsing of
  project-specific _targets_, _commands_, and _configurations_.
- Integration with `grc` for project-specific _keyword highlighting_.
- Support for multiple _roles_ for remote execution in Docker
  containers or `tmux` sessions.


The `workflow` engine is typically used to:

- Organize, orchestrate and integrate software components into a
  cohesive system.
- Separate the configuration of Open Source Software components from
  commercial ones.
- Ensure reproducibility and traceability throughout the software
  development lifecycle.
- Maintain consistency and standardization across diverse development
  environments.
- Facilitate collaboration by providing a common framework for
  defining and executing project workflows organized in a `git`
  repository.


### The `vigilia` Tester

The `vigilia` tester is based on a declarative database of test
specifications to:

- Execute tests and report on software application behavior.
- Query the test specifications as a knowledge base of implemented,
  required or desired application functions.
- Organize test specifications into hierarchically layers and
  categorize them using tags.
- Generate documentation for user-visible functionality.
- Isolate test environments using virtualization.


# Installation

`workflow` and `vigilia` support most Linux distributions.  The
regression tests use Docker files to install and verify functionality
on Debian, Ubuntu, Fedora and OpenSUSE.  The package lists within
these Dockerfiles document the prerequisites for each of those
distributions (Dockerfile for
[Debian](https://github.com/HugoCornelis/workflow-automation-engine/blob/master/vigilia/specifications/dockerfiles/Dockerfile.workflow-install-testing-debian),
[Ubuntu](https://github.com/HugoCornelis/workflow-automation-engine/blob/master/vigilia/specifications/dockerfiles/Dockerfile.workflow-install-testing-ubuntu),
[Fedora](https://github.com/HugoCornelis/workflow-automation-engine/blob/master/vigilia/specifications/dockerfiles/Dockerfile.workflow-install-testing-fedora),
[OpenSUSE](https://github.com/HugoCornelis/workflow-automation-engine/blob/master/vigilia/specifications/dockerfiles/Dockerfile.workflow-install-testing-opensuse)).

The following section provides manual installation instructions for
Ubuntu.



## Prerequisites

`workflow` and `vigilia` use [YAML](https://yaml.org/),
[JSON](https://toml.io/en/) and [TOML](https://toml.io/en/) for
configuration files.  They require the Perl modules `File::chdir`, and
`File::Find::Rule`, as well as the Perl module for integration of
Python code into Perl[^1].  `workflow` also relies `grc` for colorized
output.  Installation itself is handled via `autotools` and `make` and
requires `gcc` to compile C code.

As an example, for Ubuntu 22.04.3 LTS (Jammy), the following
prerequisites must be installed:

```
sudo apt install automake
sudo apt install grc
sudo apt install libexpect-perl
sudo apt install libfile-chdir-perl
sudo apt install libfile-find-rule-perl
sudo apt install libinline-python-perl
sudo apt install libjson-perl
sudo apt install libnet-ip-perl
sudo apt install libtoml-perl
sudo apt install libyaml-perl
sudo apt install make
```

[^1]: The Perl module that integrates with Python is called Inline::Python.  This module currently has a bug that generates warnings when multiple Python source code files are inlined.  A fix is available from https://github.com/niner/inline-python-pm but this fix is not available from package managers yet.


## Installation

First clone this repository into a local directory:

```
git clone https://github.com/HugoCornelis/workflow-automation-engine.git
cd workflow-automation-engine
```

Generate the `configure` script:

```
./autogen.sh
```

Then install `workflow` and `vigilia` using `configure` and `make`:

```
./configure
make
sudo make install
```

`workflow` and `vigilia` are now installed on your system.



# Using `workflow` and `vigilia`

## Starting a New `workflow` Project

To start a new `workflow` project named *foo*, follow these steps:

1. `workflow builtin start_project foo`

	Creates a workflow configuration for the new project named *foo*.

2. `workflow builtin install_scripts -- --commands --git`

	Makes the configuration available from any directory and
    initializes a `git` repository for it.

3. `foo-workflow --help-commands`

	Optionally displays the available commands for the project *foo*.

4. `foo-workflow examples_sh sh_single_command`

	By default the `workflow` engine installs a several example
    commands that can be adapted to your project's needs.  Use the
    `--dry-run` option to see the commands that would be executed, or
    use the `--interactions` option to see the commands and the role
    which would execute them.

5. `foo-workflow builtin add_target -- bar "Add commands to this new target that do new things" --install-commands-sh`

	Adds a new target *bar* and creates a directory with template
    examples that you can customize for your project.

6. `foo-workflow builtin workflow_add bar perform_my_specific_task -- --bash-history 3,4 --py`

	Adds a workflow to target *bar* with the operation name
    *perform_my_specific_task*, consisting of the commands found in
    the bash history.

	Through the `--py` option this workflow is implemented in a Python
    plugin file.  The `--editor` option is used to edit the workflow,
    its completions and its help page.


## Starting a new `vigilia` project

To start a new `vigilia` project named *bar*, follow these steps:

1. `vigilia configuration-create bar alpha`

	Creates a new configuration for the project bar with the role alpha.

2. `vigilia module-create 100_test_module`

	Creates a new test module named `100_test_module`.

3. `vigilia command-add 100_test_module a_tested_command "This test tests 'a_tested_command' and expects the output it currently generates`

	Adds a test command to the module that verifies the behavior of
    `a_tested_command` and checks its output against the expected
    result.

Note: This section is under development.


# Contributing

Contributions are welcome.  `workflow` and `vigilia` are released
under the GNU Affero General Public License v3 (or later), with the
additional permission for creating, distributing, and using extension
plugins under a license of choice (see [LICENSE](COPYING) and [license
exceptions](license-exceptions.txt) for details).

`workflow` and `vigilia` come with many unit and integration tests.
All new features must be covered by unit and / or integration tests.

You must write tests that provide reasonable good test coverage.



