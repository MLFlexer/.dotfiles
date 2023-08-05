# .dotfiles
![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/d63500ce-e57f-43bc-9889-a5a6c34e5d0b)

## Install
⚠️ This will install the dotfiles into `$HOME/repos/.dotfiles`. If you wish to install elsewhere you must change it manually in the bash script / nix flakes.
### Install via. curl
```
curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/install.sh | bash
```

## Optional
### Install tmux plugins
Start a tmux session:
```
tmux
```
press CTRL+SPACE followed by an uppercase I to install the plugins

### Changing the default shell
Change the shell to zsh for the current user
```
sudo usermod -s $(which zsh) $USER
```

## Updating home manager
```
home-manager switch --flake "$HOME/repos/.dotfiles/#mlflexer"
```
If it does not work, then try the following:
```
nix build $HOME/repos/.dotfiles/#homeConfigurations.mlflexer.activationPackage
$HOME/repos/.dotfiles/result/activate
```
