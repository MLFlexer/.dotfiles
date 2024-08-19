# .dotfiles

![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/05173810-e858-476c-a2b8-161b01f2237c)

## Install

> [!WARNING] 
> This will clone the repository into `$HOME/repos/.dotfiles`. If you wish to
> clone it elsewhere you must change it manually in the bash script / nix flakes.

### NixOS

Replace `<host>` with desired host

```bash
nixos-rebuild switch --use-remote-sudo --flake github:MLFlexer/.dotfiles#<host>
```

Or do it locally by cloning the repo and running:

```bash
nixos-rebuild switch --use-remote-sudo --flake $HOME/repos/.dotfiles#<host>
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

## Updating

### NixOS-rebuild switch

```bash
nixos-rebuild switch --use-remote-sudo --flake $HOME/repos/.dotfiles#<host>
```

### Home-Manager switch

```bash
home-manager switch --flake $HOME/repos/.dotfiles/#<user>
```

### Flake lock

```bash
nix flake update
```

## Cleaning

```bash
nix-collect-garbage --delete-older-than 7d
```

## Building images and tarballs

### WSL
Checkout [Building your own system tarball](https://nix-community.github.io/NixOS-WSL/building.html) for WSL.

### Raspberry Pi 5
Checkout [Building an sd-card image](https://github.com/nix-community/raspberry-pi-nix?tab=readme-ov-file#building-an-sd-card-image) for Raspberry Pi 5.

