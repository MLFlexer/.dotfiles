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

            bazarr = lib.mkIf config.arr.container.enable {
              rule =
                "Host(`bazarr.local`)"; # Local DNS rewrite in adguard: adguard -> filters -> DNS rewrites
              service = "bazarr";
              entryPoints = [ "web" ];
            };

            torrent = lib.mkIf config.arr.container.enable {
              rule =
                "Host(`torrent.local`)"; # Local DNS rewrite in adguard: adguard -> filters -> DNS rewrites
              service = "torrent";
              entryPoints = [ "web" "websecure" ];
            };
          };

          services = {
            prowlarr = lib.mkIf config.arr.container.enable {
              loadBalancer = {
                servers =
                  [{ url = "http://${config.arr.container.local_ip}:9696"; }];
              };
            };

            sonarr = lib.mkIf config.arr.container.enable {
              loadBalancer = {
                servers =
                  [{ url = "http://${config.arr.container.local_ip}:8989"; }];
              };
            };

            radarr = lib.mkIf config.arr.container.enable {
              loadBalancer = {
                servers =
                  [{ url = "http://${config.arr.container.local_ip}:7878"; }];
              };
            };

            bazarr = lib.mkIf config.arr.container.enable {
              loadBalancer = {
                servers =
                  [{ url = "http://${config.arr.container.local_ip}:6767"; }];
              };
            };

            torrent = lib.mkIf config.arr.container.enable {
              loadBalancer = {
                servers =
                  [{ url = "http://${config.arr.container.local_ip}:8173"; }];
              };
            };

            jellyfin = lib.mkIf config.arr.jelly.enable {
              loadBalancer = {
                servers = [{ url = "http://localhost:8096"; }];
              };
            };

            jellyseerr = lib.mkIf config.arr.jelly.enable {
              loadBalancer = {
                servers = [{ url = "http://localhost:5055"; }];
              };
            };

            nextcloud = lib.mkIf config.nextcloud.enable {
              loadBalancer = {
                servers = [{
                  url = "http://localhost:${
                      builtins.toString config.nextcloud.port
                    }";
                }];
              };
            };

            home-assistant = lib.mkIf config.home-assistant.enable {
              loadBalancer = {
                servers = [{
                  url = "http://localhost:${
                      builtins.toString config.home-assistant.port
                    }";
                }];
              };
            };

            adguardhome = lib.mkIf config.adguardhome.enable {
              loadBalancer = {
                servers = [{
                  url = "http://localhost:${
                      builtins.toString config.adguardhome.port
                    }";
                }];
              };
            };
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
