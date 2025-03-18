{ inputs, ... }:

let
  system = "aarch64-linux";
  user = "mlflexer";

  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = inputs.nixpkgs.lib;

  raspberry-pi-nix = inputs.raspberry-pi-nix;

in lib.nixosSystem {
  inherit system;
  specialArgs = { inherit unstable user raspberry-pi-nix; };
  modules = [
    raspberry-pi-nix.nixosModules.raspberry-pi
    raspberry-pi-nix.nixosModules.sd-image
    ./configuration.nix
    ./modules/adguard.nix
    ./modules/searxng.nix
    ./modules/jellyfin.nix
    ./modules/home-assistant.nix
    ./modules/traefik/traefik.nix
    ./modules/nextcloud/nextcloud.nix
    ./modules/arr/default.nix
  ];
}

