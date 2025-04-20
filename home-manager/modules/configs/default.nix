{ lib, ... }: {

  options = {
    isDesktop = lib.mkOption { default = false; };
    hasTouchpad = lib.mkOption { default = false; };
    steam.enable = lib.mkEnableOption "Configure as though steam is enabled";
    extra_pkgs.enable = lib.mkEnableOption "Add extra packages";

  };
  imports = [
    ./helix.nix
    ./wezterm.nix
    # ./firefox.nix
    ./zsh.nix
    ./bat.nix
    ./nvim.nix
    ./git.nix
    ./gh.nix
    ./gnome/gnome.nix
  ];

}
