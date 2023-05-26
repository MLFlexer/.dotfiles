#!/bin/bash

echo Intalling git to the current nix shell
nix-shell -p git

echo Cloning repo
git clone https://github.com/MLFlexer/.dotfiles.git

echo Symlinking config
cd .dotfiles && ./symlink_config.sh

echo Installing flake
nix run $HOME/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage

echo Activating flake
home-manager switch --flake "$HOME/.config/nix/home-manager/#mlflexer"
