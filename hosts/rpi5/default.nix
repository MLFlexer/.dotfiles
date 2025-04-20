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
    ../services
    {
      home-assistant.enable = true;
      adguardhome.enable = true;
      nextcloud.enable = true;
      traefik.enable = true;

      arr.jelly.enable = false;
      arr.enable = false;
      arr.container.enable = false;
    }

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = { inherit inputs system unstable; };
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = ./home.nix;
      };
    }
  ];
}

