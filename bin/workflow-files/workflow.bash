# #/usr/bin/env bash
# _workflow_configuration_completions()
# {
#     #! note: include the project specific prefix in the program name for project specific completions

#     COMPLETIONS=`workflow-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"`

#     COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
# }

# complete -F _workflow_configuration_completions workflow-configuration
# complete -F _workflow_configuration_completions ./workflow-configuration


_workflow_completions()
{
    #! note: include the project specific prefix in the program name for project specific completions

    COMPLETIONS=`workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g"`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

complete -F _workflow_completions workflow
complete -F _workflow_completions ./workflow

