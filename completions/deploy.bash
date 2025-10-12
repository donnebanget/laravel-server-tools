# Bash completion for deploy
_deploy_completions()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  
  # Only suggest options for first argument
  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=($(compgen -W "--init --update --help" -- "$cur"))
  fi
}

complete -F _deploy_completions deploy