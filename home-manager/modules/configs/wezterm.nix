{ config, config_dir, pkgs, ... }:
let
  # path to config directory
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink "${config_dir}";
in {
  home.packages = with pkgs; [ wezterm ];

  # Symlink files
  home.file."wezterm" = {
    enable = true;
    source = "${config_sym_dir}/wezterm";
    recursive = true;
    target = ".config/wezterm";
  };
}
