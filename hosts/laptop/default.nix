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
    host = { hostName = "laptop"; };
  };
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./modules/kanata/default.nix
    {

      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages_5.clr.icd
          rocmPackages_5.clr
          rocmPackages_5.rocminfo
          rocmPackages_5.rocm-runtime
        ];
      };
    }
  ];
}

