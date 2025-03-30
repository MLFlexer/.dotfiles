{ config, pkgs, system, inputs, ... }:

{

  imports = [ ../../home-manager/modules ];
  helix.enable = true;
  git.enable = true;
  wezterm.enable = true;
  zsh.enable = true;
  bat.enable = true;
  # gnome.enable = true;
  isDesktop = false;
  cli_tools.enable = true;
  # cli_extra.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mlflexer";
  home.homeDirectory = "/home/mlflexer";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = [ pkgs.cowsay ];
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

}
