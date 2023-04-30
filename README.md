# .dotfiles

## Install
run the install.sh script to backup old configs and create symlinks to the files in this directory.


    bash install.sh

### Nix Flake
1. install nix
2. copy everything in /nix/ to .config/nix/
3. restart the shell
4. 

    nix build ~/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
    ~/.config/nix/home-manager/result/activate


## NeoVim
Use :checkhealth to see what needs to be installed for plugins to work.

I'm using xclip to copy from nvim and tmux to the system clipboard.
