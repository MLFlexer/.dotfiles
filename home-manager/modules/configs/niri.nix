{
  config,
  lib,
  system,
  pkgs,
  unstable,
  inputs,
  ...
}:
let
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in
{

  options = {
    niri.enable = lib.mkEnableOption "Enables Niri compositor";
  };

  config = lib.mkIf config.niri.enable {

    home.packages = [
      pkgs.wl-clipboard
      pkgs.blueberry
      pkgs.impala
      pkgs.walker
      pkgs.swayosd
      pkgs.swaylock-effects
      pkgs.swayidle
      pkgs.swaybg
      unstable.xwayland-satellite
      pkgs.wttrbar
      pkgs.networkmanagerapplet
      pkgs.networkmanager
    ];
    # inputs.pkgs_unstable.wiremix
    # pamixer

    home.file = {
      "niri" = {
        enable = true;
        source = "${config_sym_dir}/niri";
        recursive = true;
        target = ".config/niri";
      };
      "walker" = {
        enable = true;
        source = "${config_sym_dir}/walker";
        recursive = true;
        target = ".config/walker";
      };
      "swayidle" = {
        enable = true;
        source = "${config_sym_dir}/swayidle";
        recursive = true;
        target = ".config/swayidle";
      };
      "swaylock" = {
        enable = true;
        source = "${config_sym_dir}/swaylock";
        recursive = true;
        target = ".config/swaylock";
      };
    };
  };
}
