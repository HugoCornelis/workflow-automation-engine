#/usr/bin/env bash
_automation_configuration_completions()
{
    COMPLETIONS=`automation-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _automation_configuration_completions automation-configuration
complete -F _automation_configuration_completions ./automation-configuration


_automation_workflow_completions()
{
    COMPLETIONS=`automation-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _automation_workflow_completions automation-workflow
complete -F _automation_workflow_completions ./automation-workflow

