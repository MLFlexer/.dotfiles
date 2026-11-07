{
  lib,
  config,
  ...
}:
{

  options = {
    mealie.enable = lib.mkEnableOption "Enables mealie";
    mealie.port = lib.mkOption { default = 9000; };
    mealie.domain = lib.mkOption { default = "mealie.mlflexer.online"; };
  };

  config = lib.mkIf config.mealie.enable {

    services.mealie = {
      enable = true;
      listenAddress = "0.0.0.0";
      port = config.mealie.port;
      database.createLocally = true;
    };
  };
}
