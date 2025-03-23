{ lib, config, ... }: {
  options = {
    traefik.enable = lib.mkEnableOption "Enables traefik";
    traefik.env_file = lib.mkOption {
      default =
        "/home/mlflexer/repos/.dotfiles/hosts/rpi5/modules/traefik/.env";
    };
  };

  config = lib.mkIf config.traefik.enable {

    services.traefik = {
      enable = true;

      staticConfigOptions = {
        global = { checkNewVersion = false; };

        entryPoints = {
          web = {
            address = ":80";
            # Redirect HTTP to HTTPS
            #   http.redirections.entryPoint = {
            #     to = "websecure";
            #     scheme = "https";
            #   };
          };
          websecure = { address = ":443"; };
        };

        certificatesResolvers.cloudflare.acme = {
          email = "malthemlarsen@gmail.com";
          storage = "/var/lib/traefik/acme.json";
          dnsChallenge = {
            provider = "cloudflare";
            resolvers = [ "1.1.1.1:53" ];
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers = {
            nextcloud = lib.mkIf config.nextcloud.enable {
              rule = "Host(`${config.nextcloud.domain}`)";
              service = "nextcloud";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };

            jellyfin = lib.mkIf config.arr.jelly.enable {
              rule = "Host(`${config.arr.jellyfin.domain}`)";
              service = "jellyfin";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };

            jellyseerr = lib.mkIf config.arr.jelly.enable {
              rule = "Host(`${config.arr.jellyseerr.domain}`)";
              service = "jellyseerr";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };

            home-assistant = lib.mkIf config.home-assistant.enable {
              rule = "Host(`${config.home-assistant.domain}`)";
              service = "home-assistant";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };

            adguardhome = lib.mkIf config.adguardhome.enable {
              rule = "Host(`${config.adguardhome.domain}`)";
              service = "adguardhome";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };

            prowlarr = lib.mkIf config.arr.container.enable {
              rule = "Host(`prowlarr.local`)";
              service = "prowlarr";
              entryPoints = [ "web" ];
            };

            sonarr = lib.mkIf config.arr.container.enable {
              rule =
                "Host(`sonarr.local`)"; # Local DNS rewrite in adguard: adguard -> filters -> DNS rewrites
              service = "sonarr";
              entryPoints = [ "web" ];
            };

            radarr = lib.mkIf config.arr.container.enable {
              rule =
                "Host(`radarr.local`)"; # Local DNS rewrite in adguard: adguard -> filters -> DNS rewrites
              service = "radarr";
              entryPoints = [ "web" ];
            };

            torrent = lib.mkIf config.arr.container.enable {
              rule =
                "Host(`torrent.local`)"; # Local DNS rewrite in adguard: adguard -> filters -> DNS rewrites
              service = "torrent";
              entryPoints = [ "web" ];
            };
          };

          services = {
            prowlarr.loadBalancer.servers =
              lib.mkIf config.arr.container.enable [{
                url = "http://${config.arr.container.local_ip}:9696";
              }];

            sonarr.loadBalancer.servers =
              lib.mkIf config.arr.container.enable [{
                url = "http://${config.arr.container.local_ip}:8989";
              }];

            radarr.loadBalancer.servers =
              lib.mkIf config.arr.container.enable [{
                url = "http://${config.arr.container.local_ip}:7878";
              }];

            torrent.loadBalancer.servers =
              lib.mkIf config.arr.container.enable [{
                url = "http://${config.arr.container.local_ip}:8173";
              }];

            jellyfin.loadBalancer.servers = lib.mkIf config.arr.jelly.enable [{
              url = "http://localhost:8096";
            }];

            jellyseerr.loadBalancer.servers =
              lib.mkIf config.arr.jelly.enable [{
                url = "http://localhost:5055";
              }];

            nextcloud.loadBalancer.servers = lib.mkIf config.nextcloud.enable [{
              url =
                "http://localhost:${builtins.toString config.nextcloud.port}";
            }];

            home-assistant.loadBalancer.servers =
              lib.mkIf config.home-assistant.enable [{
                url = "http://localhost:${
                    builtins.toString config.home-assistant.port
                  }";
              }];

            adguardhome.loadBalancer.servers =
              lib.mkIf config.adguardhome.enable [{
                url = "http://localhost:${
                    builtins.toString config.adguardhome.port
                  }";
              }];
          };
        };
      };
    };

    systemd.services.traefik = {
      serviceConfig = {
        StateDirectory = "traefik";
        EnvironmentFile = config.traefik.env_file;
      };
    };

  };
}
