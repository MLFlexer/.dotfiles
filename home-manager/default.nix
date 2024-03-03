{ inputs, ... }:

let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  ollama_pkgs = inputs.ollama-pkgs.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";
in
{
  mlflexer = inputs.home-manager.lib.homeManagerConfiguration {
    # nix build .#homeConfigurations.mlflexer.activationPackage
    #home-manager switch --flake .#mlflexer
    inherit pkgs;
    extraSpecialArgs = { inherit config_dir unstable ollama_pkgs; };
    modules = [
      inputs.nix-index-database.hmModules.nix-index # for comma integration
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
