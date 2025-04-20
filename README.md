# .dotfiles

![image](https://github.com/MLFlexer/.dotfiles/assets/75012728/05173810-e858-476c-a2b8-161b01f2237c)

### NixOS

Replace `<host>` with desired host

```sh
nixos-rebuild switch --use-remote-sudo --flake github:MLFlexer/.dotfiles#<host>
```

Or do it locally by cloning the repo and running:

```sh
nixos-rebuild switch --use-remote-sudo --flake $HOME/repos/.dotfiles#<host>
```

## Updating

### NixOS-rebuild switch

```sh
nixos-rebuild switch --use-remote-sudo --flake $HOME/repos/.dotfiles#<host>
```

### Home-Manager switch

```sh
home-manager switch --flake $HOME/repos/.dotfiles/#<user>
```

### Flake lock

Updating all inputs:

```sh
nix flake update
```

Updating specific input:

```sh
nix flake lock --update-input nixpkgs-unstable
```

## Cleaning

```sh
nix-collect-garbage --delete-older-than 7d
```

## Building images and tarballs

### WSL
Checkout [Building your own system tarball](https://nix-community.github.io/NixOS-WSL/building.html) for WSL.

### Raspberry Pi 5
Checkout [Building an sd-card image](https://github.com/nix-community/raspberry-pi-nix?tab=readme-ov-file#building-an-sd-card-image) for Raspberry Pi 5.

