{ pkgs, unstable, ... }:
let domain = "nextcloud.mlflexer.online";
in {

  systemd.services.nextcloud-setup.serviceConfig = {
    RequiresMountsFor = [ "/mnt/usbdrive2" ];
  };
  users.users.mlflexer.extraGroups = [ "usbdrive2" ];

  environment.etc."nextcloud-admin-pass".text = "mylongpassword";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = domain;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.adminuser = "admin";
    # datadir = "/home/mlflexer/nextcloud";
    # home = "/home/mlflexer/nextcloud";
    # https = true;
    # "/var/lib/nextcloud"
    settings = {
      trusted_domains = [ domain "localhost" ];
      overwritehost = domain;
      overwriteprotocol = "https";
      trusted_proxies = [ "127.0.0.1" ]; # Trust Traefik proxy
      log_type = "file";
      loglevel = 3;
    };

    database.createLocally = true;

    maxUploadSize = "4G";
    https = false;
  };

  services.nginx.virtualHosts.${domain} = {
    listen = [{
      addr = "127.0.0.1";
      port = 8080;
    }];
  };

  # services.immich = { enable = true; };
  # services.nextcloud = {
  #   enable = true;
  #   hostName = "localhost";
  #   config.adminpassFile = "/tmp/next_cloud_pass.txt";
  #
  # };

  # systemd.tmpfiles.rules =
  #   [ "d /mnt/usbdrive2/nextcloud 0555 nextcloud nextcloud -" ];

}
