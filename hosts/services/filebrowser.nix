{ lib, config, ... }:
{

  options = {
    filebrowser.enable = lib.mkEnableOption "Enables filebrowser";
    filebrowser.domain = lib.mkOption { default = "files.mlflexer.online"; };
    filebrowser.port = lib.mkOption { default = 2812; };
  };

  config = lib.mkIf config.filebrowser.enable {

    users.users.mlflexer.extraGroups = [ "filebrowser" ];

    services.filebrowser = {
      enable = true;
      settings = {
        port = config.filebrowser.port;
        address = "localhost";
        root = "/mnt/usbdrive2/files";
      };
      openFirewall = true;
    };
  };
}
