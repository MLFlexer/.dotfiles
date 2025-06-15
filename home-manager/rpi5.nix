{ inputs, ... }:
let
  system = "aarch64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs_unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit config_dir pkgs_unstable inputs system; };
  modules = [
    inputs.nix-index-database.hmModules.nix-index # comma integration
    ./modules
    {
      nvim.enable = false;
      helix.enable = true;
      git.enable = true;
      wezterm.enable = true;
      zsh.enable = true;
      bat.enable = true;
      gnome.enable = false;
      isDesktop = false;
      cli_tools.enable = true;
      cli_extra.enable = false;

      user = user;
      config_dir = config_dir;

      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        stateVersion = "25.05";
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

