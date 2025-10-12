# Bash completion for worker
_worker_completions()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  local cmd="${COMP_WORDS[1]}"
  
  # Commands
  local commands="create remove list restart status logs --help -h help"
  
  # Get list of users from /var/www
  local users=""
  if [ -d /var/www ]; then
    users=$(ls -1 /var/www 2>/dev/null | grep -v html)
  fi
  
  case $COMP_CWORD in
    1)
      # First argument: suggest commands
      COMPREPLY=($(compgen -W "$commands" -- "$cur"))
      ;;
    2)
      # Second argument: suggest users for commands that need them
      case "$cmd" in
        create|remove|restart|status|logs)
          COMPREPLY=($(compgen -W "$users" -- "$cur"))
          ;;
      esac
      ;;
    3)
      # Third argument
      case "$cmd" in
        create)
          # Suggest domains for user
          local user="$prev"
          if [ -d "/var/www/$user/data/www" ]; then
            local domains=$(ls -1 "/var/www/$user/data/www" 2>/dev/null)
            COMPREPLY=($(compgen -W "$domains" -- "$cur"))
          fi
          ;;
        logs)
          # Suggest out or err
          COMPREPLY=($(compgen -W "out err" -- "$cur"))
          ;;
        remove)
          # Suggest --force flag
          COMPREPLY=($(compgen -W "--force" -- "$cur"))
          ;;
      esac
      ;;
    4)
      # Fourth argument
      case "$cmd" in
        create)
          # Suggest queue name (common ones)
          COMPREPLY=($(compgen -W "default high low emails notifications" -- "$cur"))
          ;;
      esac
      ;;
  esac
}

complete -F _worker_completions worker