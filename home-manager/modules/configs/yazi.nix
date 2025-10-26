{
  config,
  lib,
  system,
  pkgs,
  inputs,
  ...
}:
let
  config_sym_dir = config.lib.file.mkOutOfStoreSymlink config.config_dir;
in
{
  options = {
    yazi.enable = lib.mkEnableOption "Enables yazi";
  };

  config = lib.mkIf config.yazi.enable {
    programs.yazi = {
      enable = true;
      plugins = {
        "ouch" = pkgs.yaziPlugins.ouch;
        "chmod" = pkgs.yaziPlugins.chmod;
        "mount" = pkgs.yaziPlugins.mount;
      };
      enableZshIntegration = true;
    };

    # home.packages = [ pkgs.wl-clipboard ];

    home.file = {
      "keymap.toml" = {
        enable = true;
        source = "${config_sym_dir}/yazi/keymap.toml";
        recursive = true;
        target = ".config/yazi/keymap.toml";
      };
    };
  };
}
