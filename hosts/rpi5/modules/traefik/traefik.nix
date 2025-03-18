{
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
          nextcloud = {
            rule = "Host(`nextcloud.mlflexer.online`)";
            service = "nextcloud";
            entryPoints = [ "websecure" ];
            tls.certResolver = "cloudflare";
          };

          jellyfin = {
            rule = "Host(`stream.mlflexer.online`)";
            service = "jellyfin";
            entryPoints = [ "websecure" ];
            tls.certResolver = "cloudflare";
          };

          homeassistant = {
            rule = "Host(`ha.mlflexer.online`)";
            service = "homeassistant";
            entryPoints = [ "websecure" ];
            tls.certResolver = "cloudflare";
          };

          adguard = {
            rule = "Host(`adguard.mlflexer.online`)";
            service = "adguard";
            entryPoints = [ "websecure" ];
            tls.certResolver = "cloudflare";
          };
        };
        services = {
          nextcloud.loadBalancer.servers = [{ url = "http://localhost:8080"; }];
          jellyfin.loadBalancer.servers = [{ url = "http://localhost:8096"; }];
          homeassistant.loadBalancer.servers =
            [{ url = "http://localhost:8123"; }];
          adguard.loadBalancer.servers = [{ url = "http://localhost:5000"; }];
        };
      };
    };
  };

  systemd.services.traefik = {
    serviceConfig = {
      StateDirectory = "traefik";
      EnvironmentFile =
        "/home/mlflexer/repos/.dotfiles/hosts/rpi5/modules/traefik/.env";
    };
  };

}
