{ inputs, ... }:
let
  system = "aarch64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs_unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit config_dir pkgs_unstable; };
  modules = [
    inputs.nix-index-database.hmModules.nix-index # comma integration
    ./modules/cli_tools.nix
    ./modules/configs/bat.nix
    ./modules/configs/git.nix
    ./modules/configs/zsh.nix
    ./modules/configs/wezterm.nix
    ./modules/configs/nvim.nix
    {
      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        stateVersion = "24.05";
      };

      nixpkgs.config.allowUnfree = true;

      programs.home-manager.enable = true;

      programs = {
        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
    }
  ];
}

