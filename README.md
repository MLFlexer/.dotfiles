# .dotfiles

## Install
run the install.sh script to backup old configs and create symlinks to the files in this directory.


    bash install.sh

### Nix Flake
1. Install nix
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```
2. Restart the shell
3. Temporarily install git via. nix:
```
nix-shell -p git
```
4. Clone this repo
```
git clone https://github.com/MLFlexer/.dotfiles.git
```
5. Symlink the configuration files
```
cd .dotfiles && .dotfiles/symlink_config.sh
```
6. Apply configuration flake
```
nix run $HOME/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
```
7. Activate the flake
```
home-manager switch --flake '$HOME/.config/nix/home-manager/#mlflexer'
```




6. Build flake
    nix build ~/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
7. Activate flake
    ~/.config/nix/home-manager/result/activate

2. copy everything in /nix/ to .config/nix/
3. restart the shell
4. 

    nix build ~/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
    ~/.config/nix/home-manager/result/activate


## NeoVim
Use :checkhealth to see what needs to be installed for plugins to work.

I'm using xclip to copy from nvim and tmux to the system clipboard.
