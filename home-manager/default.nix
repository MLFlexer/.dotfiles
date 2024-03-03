{ nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ollama-pkgs, neovim-nightly, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  unstable = nixpkgs-unstable.legacyPackages.${system};
  ollama_pkgs = ollama-pkgs.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";
in
{
  mlflexer = home-manager.lib.homeManagerConfiguration {
    # nix build .#homeConfigurations.mlflexer.activationPackage
    #home-manager switch --flake .#mlflexer
    inherit pkgs;
    extraSpecialArgs = { inherit config_dir unstable ollama_pkgs; };
    modules = [
      nix-index-database.hmModules.nix-index # for comma integration
      ./packages.nix
      ./sym_conf.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "23.11";
        };
        programs.home-manager.enable = true;
        programs.direnv = { enable = true; enableZshIntegration = true; nix-direnv.enable = true; };
        programs.zsh.enable = true;

        nixpkgs.config = {
          allowUnfree = true;
        };
        # nixpkgs.overlays = [
        #   neovim-nightly.overlay
        # ];
      }
    ];
  };
}
