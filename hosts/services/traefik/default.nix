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
            address = ":8888";
            # Redirect HTTP to HTTPS
            http.redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
            };
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

            jellyfin = lib.mkIf config.jelly.enable {
              rule = "Host(`${config.arr.jellyfin.domain}`)";
              service = "jellyfin";
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
              rule = "Host(`${config.adguardhome.demain}`)";
              service = "adguardhome";
              entryPoints = [ "websecure" ];
              tls.certResolver = "cloudflare";
            };
          };
          services = {
            nextcloud.loadBalancer.servers = lib.mkIf config.nextcloud.enable [{
              url =
                "http://localhost:${builtins.toString config.nextcloud.port}";
            }];
            jellyfin.loadBalancer.servers = lib.mkIf config.jellyfin.enable [{
              url =
                "http://localhost:${builtins.toString config.jellyfin.port}";
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
