#!/bin/bash

echo Intalling git to the current nix shell
nix-shell -p git

echo Cloning repo
git clone https://github.com/MLFlexer/.dotfiles.git $HOME/.dotfiles

echo Symlinking config
cd .dotfiles && $HOME/.dotfiles/symlink_config.sh

echo Installing flake
nix run $HOME/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage

echo Activating flake
home-manager switch --flake "$HOME/.config/nix/home-manager/#mlflexer"

echo Installing tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
