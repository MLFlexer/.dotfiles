#!/bin/bash

set -e

echo Installing nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. $HOME/.nix-profile/etc/profile.d/nix.sh

echo Spawning nix-shell with git and finish install
nix-shell -p git --command "curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/nix_git_install.sh | bash"

echo Restart your terminal to complete the installation
