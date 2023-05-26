# .dotfiles
![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/d63500ce-e57f-43bc-9889-a5a6c34e5d0b)

## Install
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
