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
      machine-learning.enable = false;
      host = "0.0.0.0";
      openFirewall = true;
      port = config.immich.port;
    };
  };
}
