#if [[ -n "$MC_SID" ]]; then
#  # Simple prompt inside Midnight Commander to prevent screen/buffer corruption
#  PS1='%F{cyan}%n@%m%f:%F{blue}%~%f %# '
#else
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
#fi

# Enable native and vendor tab completions
autoload -U compinit && compinit -C

# Fish-like Interactive Tab Completion
zstyle ':completion:*' menu select                        # Use arrow keys to navigate completion menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive TAB matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # Match completion menu colors to your system theme

# Load inline autosuggestions (grey ghost text)
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Do not load inside mc
#if [[ -z "$MC_SID" ]]; then
  # Load Powerlevel10k theme & config
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  source /usr/share/sblue/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
  source /usr/share/sblue/zsh/p10k.zsh
#fi

# Custom P10k overrides (must come AFTER sourcing .p10k.zsh)
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#4293EC' # Slightly lifted dark blue for parent directories

#
# Empty line between cmd + output blocks
#

# Track if we need to add an empty line
typeset -g _p10k_add_line=0

_p10k_set_cmd_flag() {
  # Extract the base command name (strip leading spaces)
  local cmd="${1#"${1%%[![:space:]]*}"}"
  cmd="${cmd%% *}"

  # Ignore screen clearing commands
  case "$cmd" in
    clear|cls|reset)
      _p10k_add_line=0
      ;;
    *)
      _p10k_add_line=1
      ;;
  esac
}

preexec_functions+=(_p10k_set_cmd_flag)

# Only insert an empty line if a command actually ran
p10k-on-pre-prompt() {
  if (( _p10k_add_line )); then
    p10k display empty_line=print
    _p10k_add_line=0
  else
    p10k display empty_line=hide
  fi
}

#
# Better history handling
#
HISTFILE=~/.zsh_history
HISTSIZE=40000
SAVEHIST=40000
setopt SHARE_HISTORY          # Share history across all active terminal tabs
setopt HIST_IGNORE_DUPS       # Don't record duplicate consecutive commands
setopt HIST_IGNORE_SPACE      # Skip recording commands that start with a space
setopt HIST_IGNORE_ALL_DUPS   # Delete old duplicate entries if a new duplicate is saved
setopt HIST_FIND_NO_DUPS      # Do not display duplicates when searching history
setopt HIST_SAVE_NO_DUPS      # Omit older duplicate commands when saving history

#
# Better commands
#
export EZA_COLORS="da=38;5;248:sn=38;5;248:sb=38;5;248:uu=38;5;248:gu=38;5;248:per=38;5;248:ga=38;5;248:gm=38;5;248:uR=31;1:gR=31;1"
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group --git --group-directories-first"
alias la="eza -la --icons --group --git --group-directories-first"
alias cat="bat"

# Better cd
eval "$(zoxide init zsh --cmd cd)" # smart cd replacement
setopt AUTO_CD            # Type 'dirname' directly without 'cd' to enter it

# Better history search
source <(fzf --zsh)

# Better tab completions
source /usr/share/sblue/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

