# .dotfiles
![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/05173810-e858-476c-a2b8-161b01f2237c)


## Install
⚠️ This will install the dotfiles into `$HOME/repos/.dotfiles`. If you wish to install elsewhere you must change it manually in the bash script / nix flakes.

### NixOS
Replace `<host_name>` with desired host
```bash
sudo nixos-rebuild switch --flake github:MLFlexer/.dotfiles#<host_name>
```

or do it locally by cloning the repo and running:
```bash
sudo nixos-rebuild switch --flake $HOME/repos/.dotfiles#<host_name>
```

### Home-Manager
#### NixOS distribution
```bash
nix-shell -p git --command "curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/nix_git_install.sh | bash"
```

#### Non-NixOS distribution
```bash
curl -sSL https://raw.githubusercontent.com/MLFlexer/.dotfiles/main/install.sh | bash
```

## Optional
### Install tmux plugins
Start a tmux session:
```bash
tmux
```
press CTRL+SPACE followed by an uppercase I to install the plugins

### Changing the default shell
Change the shell to zsh for the current user
```bash
sudo usermod -s $(which zsh) $USER
```

## Updating
### NixOS
```bash
sudo nixos-rebuild switch --flake $HOME/repos/.dotfiles#<host_name>
``` 
### Home-Manager
```bash
home-manager switch --flake "$HOME/repos/.dotfiles/#mlflexer"
```
If it does not work, then try the following:
```bash
nix build $HOME/repos/.dotfiles/#homeConfigurations.mlflexer.activationPackage
$HOME/repos/.dotfiles/result/activate
```
