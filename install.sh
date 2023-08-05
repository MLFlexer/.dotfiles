#!/bin/bash

set -e

echo Installing nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
. $HOME/.nix-profile/etc/profile.d/nix.sh

echo Spawning nix-shell with git and finish install
nix-shell -p git --command "curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/nix_git_install.sh | bash"

echo
echo Install tmux plugins by pressing CTRL + SPACE followed by I \(Uppercase\)
echo
echo Change shell to zsh by typing:
echo 'sudo usermod -s $(which zsh) $USER'
