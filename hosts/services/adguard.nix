{ lib, config, ... }: {

  options = {
    adguardhome.enable = lib.mkEnableOption "Enables adguardhome";
    adguardhome.port = lib.mkOption { default = 5000; };
  };

  config = lib.mkIf config.adguardhome.enable {
    services.adguardhome = {
      enable = true;
      openFirewall = true;
      allowDHCP = true;
      port = config.adguardhome.port;
      settings = {
        http.address = "0.0.0.0:${builtins.toString config.adguardhome.port}";
      };
    };
  };
}
