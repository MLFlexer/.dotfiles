#!/bin/bash

set -e

echo Creating repos directory
mkdir -p $HOME/repos

echo Cloning dotfiles
git clone https://github.com/MLFlexer/.dotfiles.git $HOME/repos/.dotfiles

echo Creating nix config
mkdir -p $HOME/.config/nix
touch $HOME/.config/nix/nix.conf
curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/home-manager/config/nix/nix.conf -o $HOME/.config/nix/nix.conf

echo Activating and installing home manager flake
echo Please provide home-manager user
read hm_user
home-manager switch --flake "$HOME/repos/.dotfiles/#$hm_user"
