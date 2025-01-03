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
  specialArgs = {
    inherit unstable user raspberry-pi-nix;
  };
  modules =
    [ 
    raspberry-pi-nix.nixosModules.raspberry-pi 
    ./configuration.nix
    ./modules/adguard.nix
    ./modules/searxng.nix
    ];
}

