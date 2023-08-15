{ nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";
in
{
  mlflexer = home-manager.lib.homeManagerConfiguration {
    # nix build .#homeConfigurations.mlflexer.activationPackage
    #home-manager switch --flake .#mlflexer
    inherit pkgs;
    extraSpecialArgs = { inherit config_dir; };
    modules = [
      nix-index-database.hmModules.nix-index # for comma integration
      ./packages.nix
      ./sym_conf.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "23.05";
        };
        programs.home-manager.enable = true;
        nixpkgs.config = {
          allowUnfree = true;
        };
      }
    ];
  };
}
