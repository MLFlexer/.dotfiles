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
    host = { hostName = "wsl"; };
  };
  modules = [
    {
      wsl.useWindowsDriver = true;
      system.stateVersion = "24.05";
      wsl.enable = true;
      wsl.defaultUser = user;
      hardware.opengl.setLdLibraryPath = true;
      hardware.nvidia-container-toolkit.enable = true;
    }
    ./configuration.nix
    inputs.nixos-wsl.nixosModules.default
  ];
}
