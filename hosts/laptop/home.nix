{
  config,
  pkgs,
  system,
  inputs,
  ...
}:

{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    ../../home-manager/modules
  ];

  helix.enable = true;
  git.enable = true;
  wezterm.enable = true;
  zsh.enable = true;
  bat.enable = true;
  gnome.enable = true;
  isDesktop = false;
  hasTouchpad = true;
  cli_tools.enable = true;
  gh.enable = true;
  cli_extra.enable = true;
  extra_pkgs.enable = false;
  niri.enable = true;
  waybar.enable = false;

  home.username = "mlflexer";
  home.homeDirectory = "/home/mlflexer";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

}
