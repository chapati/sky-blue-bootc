* red color in terminal (confirm delete in mc)
* red terminal title on root in ssh & in prod

1. Smart Directory Navigation (zoxide)
Replaces cd by learning your most-used directories. Once installed, typing z buzz instantly jumps to ~/projects/buzz-back from anywhere in your system.

    Install: sudo zypper in zoxide

    ~/.zshrc addition:
    Bash

    eval "$(zoxide init zsh)"

2. Fuzzy History & Path Search (fzf)
Replaces Zsh's standard Ctrl + R search with an interactive fuzzy finder for previous commands and file paths.

    Install: sudo zypper in fzf

    ~/.zshrc addition:
    Bash

    source <(fzf --zsh)