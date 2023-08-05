#!/bin/bash

set -e

echo Creating repos directory
mkdir -p $HOME/repos

echo Cloning dotfiles
git clone https://github.com/MLFlexer/.dotfiles.git $HOME/repos/.dotfiles

echo Creating nix config
mkdir -p $HOME/.config/nix
touch $HOME/.config/nix/nix.conf
curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/nix.conf -o $HOME/.config/nix/nix.conf

echo Activating and installing home manager flake
nix run $HOME/repos/.dotfiles/#homeConfigurations.mlflexer.activationPackage

echo Installing tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
