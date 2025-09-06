#/usr/bin/env bash
_feature_testing_configuration_completions()
{
    COMPLETIONS=`feature-testing-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

# complete -F _feature_testing_configuration_completions feature-testing-configuration
# complete -F _feature_testing_configuration_completions ./feature-testing-configuration
complete -F _feature_testing_configuration_completions feature-testing-configuration -o bashdefault -o default
complete -F _feature_testing_configuration_completions ./feature-testing-configuration -o bashdefault -o default


_feature_testing_workflow_completions()
{
    COMPLETIONS=`feature-testing-workflow --bash-completion "$COMP_LINE" $COMP_CWORD $COMP_POINT | sed 's/[[0-9;]*m//g'`

    COMPREPLY=($(compgen -W "$COMPLETIONS" -- "${COMP_WORDS[$COMP_CWORD]}"))
}

# complete -F _feature_testing_workflow_completions feature-testing-workflow
# complete -F _feature_testing_workflow_completions ./feature-testing-workflow
complete -F _feature_testing_workflow_completions feature-testing-workflow -o bashdefault -o default
complete -F _feature_testing_workflow_completions ./feature-testing-workflow -o bashdefault -o default

