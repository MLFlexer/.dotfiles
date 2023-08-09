{ lib, nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  user = "mlflexer";
in
{
  mlflexer_home_manager = home-manager.lib.homeManagerConfiguration {
    #home-manager switch --flake .#mlflexer_home_manager
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
