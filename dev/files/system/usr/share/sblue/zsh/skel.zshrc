# ~/.zshrc

#
# Load system-wide sblue defaults
#
source /usr/share/sblue/zsh/sblue.zshrc


# =====================================================================
#                       USER CONFIGURATION AREA
# Add your personal aliases, paths, and custom plugins below this line.
# =====================================================================


#
# Syntax Highlighting (Must remain at the absolute bottom)
#
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[global-assign]='fg=cyan,bold'

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zle_highlight=(paste:none)
