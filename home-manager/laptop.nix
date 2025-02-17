{ inputs, ... }:
let
  system = "x86_64-linux";
  # pkgs = inputs.nixpkgs.legacyPackages.${system};
  # pkgs_unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  pkgs = import inputs.nixpkgs {
    system = "${system}";
    config = { allowUnfree = true; };
  };
  pkgs_unstable = import inputs.nixpkgs-unstable {
    system = "${system}";
    config = { allowUnfree = true; };
  };
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";

in inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit config_dir pkgs_unstable; };
  modules = [
    inputs.nix-index-database.hmModules.nix-index # comma integration
    ./modules/cli_tools.nix
    ./modules/cli_extra.nix
    ./modules/configs/bat.nix
    ./modules/configs/git.nix
    ./modules/configs/zsh.nix
    ./modules/configs/wezterm.nix
    ./modules/configs/nvim.nix
    ./modules/configs/helix.nix
    ./modules/configs/gh.nix
    {
      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        stateVersion = "24.11";
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

