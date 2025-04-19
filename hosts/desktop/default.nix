{ inputs, ... }:
let
  system = "x86_64-linux";
  user = "mlflexer";

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = inputs.nixpkgs.lib;

in lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit pkgs unstable user inputs;
    host = { hostName = "desktop"; };
  };
  modules = [ ./configuration.nix ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.extraSpecialArgs = { inherit inputs system unstable; };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.mlflexer = ./home.nix;
    }
     ];
}

