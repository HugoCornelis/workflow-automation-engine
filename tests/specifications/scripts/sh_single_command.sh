#!/bin/sh

# argument-testing-workflow examples_sh sh_single_command 'abc  def'  ghi
#
# # /home/hugo/projects/workflow-automation-engine/source/snapshots/master/testing/argument-testing-commands-data/examples_sh/sh_single_command.sh 'abc  def' 'ghi'
# #
# This script tests whether command arguments are passed correctly and quoted correctly.
# arguments are:
# abc  def ghi

echo This script tests whether command arguments are passed correctly and quoted correctly.

echo arguments are:

echo "$*"

