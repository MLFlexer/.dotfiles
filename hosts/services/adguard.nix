{ lib, config, ... }: {

  options = {
    adguardhome.enable = lib.mkEnableOption "Enables adguardhome";
    adguardhome.port = lib.mkOption { default = 5000; };
    adguardhome.domain = lib.mkOption { default = "adguard.mlflexer.online"; };
  };

  config = lib.mkIf config.adguardhome.enable {
    networking.firewall.allowedUDPPortRanges = [{
      from = 53;
      to = 53;
    }];

    services.adguardhome = {
      enable = true;
      openFirewall = true;
      allowDHCP = true;
      port = config.adguardhome.port;
      settings = {
        http.address = "0.0.0.0:${builtins.toString config.adguardhome.port}";
        users = [{
          name = "admin";
          password = "$2y$05$ZSmxS54ZBjJbtzwRB4ChZ.S8qe7wlgvAQzUdcgKMDx8ki9AWVNBFG";
        }];
        log = {
          max_size = 1024;
          max_age = 1;
        };
        querylog = {
          interval = "24h";
          enabled = true;
        };
        filtering = {
      rewrites = [
        {
          domain = "prowlarr.local";
          answer = "192.168.0.42";
          enabled = true;
        }
        {
          domain = "sonarr.local";
          answer = "192.168.0.42";
          enabled = true;
        }
        {
          domain = "radarr.local";
          answer = "192.168.0.42";
          enabled = true;
        }
        {
          domain = "bazarr.local";
          answer = "192.168.0.42";
          enabled = true;
        }
        {
          domain = "torrent.local";
          answer = "192.168.0.42";
          enabled = true;
        }
      ];
    };
      };
    };
  };
}
