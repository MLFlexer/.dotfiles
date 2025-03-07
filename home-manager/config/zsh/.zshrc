# Nix
if [ -e /home/mlflexer/.nix-profile/etc/profile.d/nix.sh ]; then . /home/mlflexer/.nix-profile/etc/profile.d/nix.sh; fi
NIX_PROFILE=$HOME/.nix-profile

# Wezterm Shell integration
source "$ZDOTDIR/wezterm.sh"

# Autoload functions
autoload -U $HOME/.config/zsh/functions/*

# Source aliases
export ALIASES_FILE="$ZDOTDIR/.aliases"
source $ALIASES_FILE

# Set p10k theme
source $ZDOTDIR/.p10k.zsh
POWERLEVEL9K_CONFIG_FILE="$ZDOTDIR/.p10k.zsh"
source $NIX_PROFILE/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

# Autosuggestions for zsh
source $NIX_PROFILE/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Zsh syntax highlighting
source $NIX_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Initialize zsh completions directory
autoload -U compinit -d "$HOME"/.cache/zsh/zcompdump-"$ZSH_VERSION"
zstyle ':completion:*' menu select
_comp_options+=(globdots) # include hidden files

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors $LS_COLORS

# Add shift-tab to reverse menu
bindkey '^[[Z' reverse-menu-complete

bindkey '^H' backward-kill-word

autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# Initialize zoxide
eval "$(zoxide init zsh)"

# atuin
eval "$(atuin init zsh --disable-up-arrow)"

# direnv
eval "$(direnv hook zsh)"
