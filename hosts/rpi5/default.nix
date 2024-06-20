{ inputs, ... }:
let
  system = "aarch64-linux";
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

  # for raspberry pi
  nixos-hardware = inputs.nixos-hardware;
  raspberry-pi-nix = inputs.raspberry-pi-nix;

in
{
  rpi5 = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit pkgs unstable user raspberry-pi-nix inputs;
      host = {
        hostName = "rpi5";
      };
    };
    modules = [
      ./configuration.nix
      # ./hardware-configuration.nix
      # nixos-hardware.nixosModules.raspberry-pi-5
      raspberry-pi-nix.nixosModules.raspberry-pi
      { raspberry-pi-nix.libcamera-overlay.enable = false; }
    ];

  };
}
