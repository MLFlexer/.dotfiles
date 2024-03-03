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
in
{
  # Laptop profile
  laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit pkgs unstable user inputs;
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
