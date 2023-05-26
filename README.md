# .dotfiles
![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/d63500ce-e57f-43bc-9889-a5a6c34e5d0b)

## Install
1. Install nix
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
```
2. Restart the shell

### Install via. curl
3. Install via. install.sh
```
curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/90594c0dcc65ac360e238d7513669cf3687d70c9/install.sh | bash
```

### Install manually
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
cd .dotfiles && ./symlink_config.sh
```
6. Apply configuration flake
```
nix run $HOME/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
```
7. Activate the flake
```
home-manager switch --flake "$HOME/.config/nix/home-manager/#mlflexer"
```
8. Install tmux plugin manager
```
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
```

### Install tmux plugins
Start a tmux session
```
tmux
```
press CTRL+SPACE followed by an uppercase I to install the plugins

### Optional
Change the shell to zsh for the current user
```
sudo usermod -s $(which zsh) $USER
```

## Updating home.nix
```
home-manager switch --flake "$HOME/.config/nix/home-manager/#mlflexer"
```
If it does not work, then use the following:
```
nix build ~/.config/nix/home-manager/#homeConfigurations.mlflexer.activationPackage
$HOME/.config/nix/home-manager/result/activate
```
