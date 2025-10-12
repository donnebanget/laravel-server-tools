# Bash completion for worker
_worker_completions()
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # Commands
  local commands="create remove list restart status logs help"
  
  # Get list of users from /var/www (exclude common non-user directories)
  local users=""
  if [ -d /var/www ]; then
    users=$(find /var/www -maxdepth 1 -mindepth 1 -type d -printf "%f\n" 2>/dev/null | grep -v "^html$\|^httpd-cert$\|^index.html$")
  fi
  
  # Check if first word after 'worker' is a valid command
  local cmd=""
  if [ $COMP_CWORD -ge 1 ]; then
    case "${COMP_WORDS[1]}" in
      create|remove|list|restart|status|logs|help|--help|-h)
        cmd="${COMP_WORDS[1]}"
        ;;
    esac
  fi
  
  # If no command yet, suggest commands
  if [ -z "$cmd" ] && [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=($(compgen -W "$commands --help -h" -- "$cur"))
    return 0
  fi
  
  # Handle completions based on command and position
  case "$cmd" in
    create)
      case $COMP_CWORD in
        2)
          # Suggest users
          COMPREPLY=($(compgen -W "$users" -- "$cur"))
          ;;
        3)
          # Suggest domains for the user
          local user="${COMP_WORDS[2]}"
          if [ -d "/var/www/$user/data/www" ]; then
            local domains=$(find "/var/www/$user/data/www" -maxdepth 1 -mindepth 1 -type d -printf "%f\n" 2>/dev/null)
            COMPREPLY=($(compgen -W "$domains" -- "$cur"))
          fi
          ;;
        4)
          # Suggest common queue names
          COMPREPLY=($(compgen -W "default high low emails notifications" -- "$cur"))
          ;;
      esac
      ;;
    remove)
      case $COMP_CWORD in
        2)
          # Suggest users
          COMPREPLY=($(compgen -W "$users" -- "$cur"))
          ;;
        3)
          # Suggest --force flag
          COMPREPLY=($(compgen -W "--force" -- "$cur"))
          ;;
      esac
      ;;
    restart|status)
      if [ $COMP_CWORD -eq 2 ]; then
        # Suggest users
        COMPREPLY=($(compgen -W "$users" -- "$cur"))
      fi
      ;;
    logs)
      case $COMP_CWORD in
        2)
          # Suggest users
          COMPREPLY=($(compgen -W "$users" -- "$cur"))
          ;;
        3)
          # Suggest out or err
          COMPREPLY=($(compgen -W "out err" -- "$cur"))
          ;;
      esac
      ;;
    list|help|--help|-h)
      # No additional completion needed
      COMPREPLY=()
      ;;
  esac
}

complete -F _worker_completions worker