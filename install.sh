#!/bin/bash

set -e

echo Intalling git to the current nix shell
nix-shell -p git

echo Cloning repo
cd $HOME
git clone https://github.com/MLFlexer/.dotfiles.git $HOME/.dotfiles

echo Symlinking config
cd $HOME/.dotfiles && $HOME/.dotfiles/symlink_config.sh

echo Installing flake
nix run $HOME/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage

echo Activating flake
home-manager switch --flake "$HOME/.config/nix/home-manager/#mlflexer"

echo Installing tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

echo
echo
echo
echo Install tmux plugins by pressing CTRL + SPACE followed by I \(Uppercase\)
