# Nix
if [ -e /home/mlflexer/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mlflexer/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
NIX_PROFILE=$HOME/.nix-profile

# Source aliases
export ALIASES_FILE="$ZDOTDIR/.aliases"
source $ALIASES_FILE

# Autoload functions
autoload -U $HOME/.config/zsh/functions/*

# Set p10k theme
source $ZDOTDIR/.p10k.zsh
POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/.p10k.zsh"
source $NIX_PROFILE/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# Initialize zoxide
eval "$(zoxide init zsh)"

# Autosuggestions for zsh
source $NIX_PROFILE/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source $NIX_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize zsh completions directory
compinit -d "$HOME"/.cache/zsh/zcompdump-"$ZSH_VERSION"

# Add t to path (tmux session switcher script)
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH
