#/usr/bin/env bash
_neurospaces_configuration_completions()
{
    #! note: include the project specific prefix in the program name for project specific completions

    COMPLETIONS=`neurospaces-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _neurospaces_configuration_completions neurospaces-configuration
complete -F _neurospaces_configuration_completions ./neurospaces-configuration


_neurospaces_workflow_completions()
{
    #! note: include the project specific prefix in the program name for project specific completions

    COMPLETIONS=`neurospaces-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

# complete -F _neurospaces_workflow_completions workflow
# complete -F _neurospaces_workflow_completions ./workflow

complete -F _neurospaces_workflow_completions neurospaces-workflow
complete -F _neurospaces_workflow_completions ./neurospaces-workflow

