#!/usr/bin/perl -w

package Command;

use strict;

use warnings;

# set your PYTHONPATH to include the appropriate directories if this is needed
#
# export PYTHONPATH=$HOME/projects/my-python-modules-directory

BEGIN
{
	if (not exists $ENV{PYTHONPATH})
	{
		$ENV{PYTHONPATH} = "/home/hugo/projects/workflow-automation-engine/source/snapshots/master/tests/specifications/workflow-configurations/feature-testing/feature-testing-commands-data/cache";
	}
}

use Inline Python => <<'PYTHON';



#!/usr/bin/python3

def python_python_command(argv):
    command = "echo 'python_command from bash (1)'"
    execute_command(command)
    command_array = [
        "echo 'python_command from bash (2)'",
        "echo 'python_command from bash (3)'"
    ]
    execute_command_array(command_array)


def python_python_command_completions(command, argv):
    completions_hash = {
           "1._<your_completion_without_spaces_here>": "explain_the_purpose_of_the_completion_here",
           "2._<another_completion_here>": "the_numbers_preserve_the_order_for_this_example",
           "3._Don't_use_spaces_in_your_completions,_because_they_confuse_bash": "further_explanation",
           "4._Look_at_the_completion_function_of_python_single_command_completions_to_understand_how_it_works": "further_explanation",
          }

    return completions_hash


def python_python_command_help(command, perl_argv):
    return f"python_python_command {command} help page"


PYTHON




# return success

1;


