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
      inputs.nix-index-database.hmModules.nix-index # comma integration
      ./packages.nix
      ./sym_conf.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          stateVersion = "23.11";
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
