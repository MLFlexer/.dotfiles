{ lib, config, ... }:
{

  options = {
    freshrss.enable = lib.mkEnableOption "Enables freshrss";
    freshrss.domain = lib.mkOption { default = "freshrss.mlflexer.online"; };
  };

  config = lib.mkIf config.freshrss.enable {
    services.freshrss = {
      enable = true;
      baseUrl = "https://${config.freshrss.domain}";
      virtualHost = config.freshrss.domain;
      passwordFile = ./passwordfile;
    };
  };
}
