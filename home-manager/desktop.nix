{ inputs, ... }:
let
  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {
    system = "${system}";
    config = {
      allowUnfree = true;
    };
  };
  pkgs_unstable = import inputs.nixpkgs-unstable {
    system = "${system}";
    config = {
      allowUnfree = true;
    };
  };
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";
in
inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit pkgs_unstable inputs system; };
  modules = [
    inputs.nix-index-database.hmModules.nix-index # comma integration
    ./modules
    {
      nvim.enable = true;
      helix.enable = true;
      git.enable = true;
      wezterm.enable = true;
      zsh.enable = true;
      bat.enable = true;
      gnome.enable = true;
      isDesktop = true;
      cli_tools.enable = true;
      cli_extra.enable = true;

      user = user;
      config_dir = config_dir;

      home = {
        username = user;
        homeDirectory = "/home/${user}";
        stateVersion = "25.11";
      };

      programs.home-manager.enable = true;
      nixpkgs.config.allowUnfree = true;

      programs.git = {
        enable = true;
        lfs.enable = true;
      };

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
