# Bash completion for worker
_worker_completions()
{
  local users=$(ls /var/www)
  COMPREPLY=($(compgen -W "${users}" -- "${COMP_WORDS[1]}"))
}
complete -F _worker_completions worker
