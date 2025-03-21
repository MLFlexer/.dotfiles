{ lib, ... }: {

  options = {
    isDesktop = lib.mkOption { default = false; };
    steam.enable = lib.mkEnableOption "Configure as though steam is enabled";
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
