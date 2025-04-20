{ config, pkgs, system, inputs, ... }:

{
  imports = [ ../../home-manager/modules ];
  helix.enable = true;
  git.enable = true;
  wezterm.enable = false;
  zsh.enable = true;
  bat.enable = true;
  gnome.enable = false;
  isDesktop = false;
  hasTouchpad = false;
  cli_tools.enable = true;
  gh.enable = true;
  cli_extra.enable = false;
  extra_pkgs.enable = false;

  home.username = "mlflexer";
  home.homeDirectory = "/home/mlflexer";
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

}
