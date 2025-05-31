{ lib, config, pkgs, ... }: {

  options = {
    nextcloud.enable = lib.mkEnableOption "Enables nextcloud";
    nextcloud.port = lib.mkOption { default = 8080; };
    nextcloud.domain = lib.mkOption { default = "nextcloud.mlflexer.online"; };
  };

  config = lib.mkIf config.nextcloud.enable {

    # TODO: move this 
    systemd.services.nextcloud-setup.serviceConfig = {
      RequiresMountsFor = [ "/mnt/usbdrive2" ];
    };
    # TODO: move this 
    users.users.mlflexer.extraGroups = [ "usbdrive2" ];

    environment.etc."nextcloud-admin-pass".text = "admin";

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud30;
      hostName = config.nextcloud.domain;
      config.adminuser = "admin";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
      # TODO: move this 
      # datadir = "/home/mlflexer/nextcloud";
      # home = "/home/mlflexer/nextcloud";
      # "/var/lib/nextcloud"
      settings = {
        trusted_domains = [ config.nextcloud.domain "localhost" ];
        overwritehost = config.nextcloud.domain;
        overwriteprotocol = "https";
        trusted_proxies = [ "127.0.0.1" ]; # Trust Traefik proxy
        log_type = "file";
        loglevel = 3;
      };

      database.createLocally = true;

      maxUploadSize = "4G";
      https = false; # done via. proxy
    };

    # TODO: move this 
    # needed to serve php
    services.nginx.virtualHosts.${config.nextcloud.domain} = {
      listen = [{
        addr = "127.0.0.1";
        port = config.nextcloud.port;
      }];
    };

  };
}
