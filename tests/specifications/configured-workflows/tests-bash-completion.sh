#/usr/bin/env bash
_tests_configuration_completions()
{
    COMPLETIONS=`tests-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _tests_configuration_completions tests-configuration
complete -F _tests_configuration_completions ./tests-configuration


_tests_workflow_completions()
{
    COMPLETIONS=`tests-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _tests_workflow_completions tests-workflow
complete -F _tests_workflow_completions ./tests-workflow

