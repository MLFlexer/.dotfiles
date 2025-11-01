{ config, lib, system, pkgs, inputs, unstable, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { waybar.enable = lib.mkEnableOption "Enables Waybar"; };

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd.target = "niri-session";
      package = unstable.waybar;
    };

    home.file = {
      "waybar" = {
        enable = true;
        source = "${config_sym_dir}/waybar";
        recursive = true;
        target = ".config/waybar";
      };
    };
  };
}
