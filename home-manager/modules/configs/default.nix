{ lib, ... }: {

  options = {
    isDesktop = lib.mkOption { default = false; };
    hasTouchpad = lib.mkOption { default = false; };
    steam.enable = lib.mkEnableOption "Configure as though steam is enabled";
    extra_pkgs.enable = lib.mkEnableOption "Add extra packages";

  };
  imports = [
    # ./firefox.nix
    ./bat.nix
    ./gh.nix
    ./git.nix
    ./gnome/gnome.nix
    ./helix.nix
    ./niri.nix
    ./nvim.nix
    ./waybar.nix
    ./wezterm.nix
    ./zsh.nix
  ];

}
