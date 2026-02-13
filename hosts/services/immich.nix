{
  lib,
  config,
  unstable,
  ...
}:
{

  options = {
    immich.enable = lib.mkEnableOption "Enables immich";
    immich.port = lib.mkOption { default = 2283; };
    immich.domain = lib.mkOption { default = "immich.mlflexer.online"; };
  };

  config = lib.mkIf config.immich.enable {

    services.immich = {
      enable = true;
      # package = unstable.immich;
      openFirewall = true;
      # database.enableVectors = false;
      port = config.immich.port;
    };
  };
}
