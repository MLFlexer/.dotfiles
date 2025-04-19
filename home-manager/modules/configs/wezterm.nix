{ config, lib, pkgs, ... }:
let config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in {
  options = { wezterm.enable = lib.mkEnableOption "Enables Wezterm config"; };

  config = lib.mkIf config.wezterm.enable {
    home.packages = with pkgs; [ wezterm ];

    home.file."wezterm" = {
      enable = true;
      source = "${config_sym_dir}/wezterm";
      recursive = true;
      target = ".config/wezterm";
    };
  };
}
