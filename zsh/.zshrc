# Nix
if [ -e /home/mlflexer/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mlflexer/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
NIX_PROFILE=$HOME/.nix-profile

# Homebrew
# export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:$PATH

# Source aliases
export ALIASES_FILE="$ZDOTDIR/.aliases"
source $ALIASES_FILE

# Autoload functions
autoload -U $HOME/.config/zsh/functions/*

# Set p10k theme
source $ZDOTDIR/.p10k.zsh
POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/.p10k.zsh"
source $NIX_PROFILE/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# Add t to path
export PATH=$HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin:$PATH

# Initialize zoxide
eval "$(zoxide init zsh)"

# FZF tab suggestions for zsh
# source $NIX_PROFILE/share/fzf-tab/fzf-tab.plugin.zsh

# Autosuggestions for zsh
source $NIX_PROFILE/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source $NIX_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
