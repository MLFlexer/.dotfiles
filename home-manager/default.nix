{ inputs, ... }:

let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  pkgs_unstable = inputs.nixpkgs-unstable.legacyPackages.${system};
  user = "mlflexer";
  config_dir = "/home/${user}/repos/.dotfiles/home-manager/config";
in
{
  mlflexer = inputs.home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit config_dir pkgs_unstable; };
    modules = [
      inputs.nix-index-database.hmModules.nix-index # comma integration
      ./packages.nix
      ./sym_conf.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "24.05";
        };

        nixpkgs.config = {
          allowUnfree = true;
        };

        programs = {
          home-manager.enable = true;

          direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };

          bat = {
            enable = true;
            config = {
              pager = "less -FR";
              theme = "tokoyonight_moon";
            };
            themes = {
              tokoyonight_moon = {
                src = pkgs.fetchFromGitHub {
                  owner = "folke";
                  repo = "tokyonight.nvim";
                  rev = "610179f7f12db3d08540b6cc61434db2eaecbcff";
                  sha256 = "sha256-mzCdcf7FINhhVLUIPv/eLohm4qMG9ndRJ5H4sFU2vO0=";
                };
                file = "extras/sublime/tokyonight_moon.tmTheme";
              };
            };
          };

          git = {
            enable = true;
            difftastic = {
              enable = true;
            };
            userEmail = "75012728+MLFlexer@users.noreply.github.com";
            userName = "MLFlexer";
          };
        };
      }
    ];
  };
}
