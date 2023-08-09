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

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user home-manager pkgs;
          host = {
            hostName = "laptop";
          };
        };
        home-manager.users.${user} = {

          imports = [ ./laptop/home.nix ];
        };
      }
    ];
  };

  # other profiles ...
}
