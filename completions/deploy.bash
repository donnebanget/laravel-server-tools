# Bash completion for deploy
_deploy_completions()
{
  COMPREPLY=($(compgen -W "--init --update" -- "${COMP_WORDS[1]}"))
}
complete -F _deploy_completions deploy
