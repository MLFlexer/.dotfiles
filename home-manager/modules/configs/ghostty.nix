{
  config,
  lib,
  pkgs,
  ...
}:
let
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in
{
  options = {
    ghostty.enable = lib.mkEnableOption "Enables ghostty config";
  };

  config = lib.mkIf config.ghostty.enable {
    home.packages = with pkgs; [ ghostty ];

    home.file."ghostty" = {
      enable = true;
      source = "${config_sym_dir}/ghostty";
      recursive = true;
      target = ".config/ghostty";
    };
  };
}
