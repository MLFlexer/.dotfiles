{ lib, nixpkgs, nixpkgs-unstable, home-manager, ... }:

let
  system = "x86_64-linux";
  user = "mlflexer";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  # Laptop profile
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit pkgs unstable user;
      host = {
        hostName = "laptop";
      };
    };
    modules = [
      ./laptop/configuration.nix
      ./laptop/hardware-configuration.nix
    ];
  };

  # other profiles ...
}
