{ lib, nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  user = "mlflexer";
in
{
  mlflexer = home-manager.lib.homeManagerConfiguration {
    # nix build .#homeConfigurations.mlflexer.activationPackage
    #home-manager switch --flake .#mlflexer
    inherit pkgs;
    extraSpecialArgs = { inherit system user; };
    modules = [
      ./packages.nix
      ./sym_conf.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "23.05";
        };
        programs.home-manager.enable = true;
      }
    ];
  };
}
