{
  services.traefik = {
  enable = true;

  staticConfigOptions = {
    global = {
      checkNewVersion = false;
    };
    
    entryPoints = {
      web = {
        address = ":8888";
        # Redirect HTTP to HTTPS
        http.redirections.entryPoint = {
          to = "websecure";
          scheme = "https";
        };
      };
      websecure = {
        address = ":443";
      };
    };

    certificatesResolvers.cloudflare.acme = {
      email = "malthemlarsen@gmail.com";
      storage = "/var/lib/traefik/acme.json";
      dnsChallenge = {
        provider = "cloudflare";
        resolvers = ["1.1.1.1:53"];
      };
    };
  };

  dynamicConfigOptions = {
    http = {
      routers = {
        homeassistant = {
          rule = "Host(`mlflexer.online`)";
          service = "homeassistant";
          entryPoints = ["websecure"];
          tls.certResolver = "cloudflare";
        };

        adguard = {
          rule = "Host(`adguard.mlflexer.online`)";
          service = "adguard";
          entryPoints = ["websecure"];
          tls.certResolver = "cloudflare";
        };
      };
      services = {
        homeassistant.loadBalancer.servers = [{
          url = "http://localhost:8123";
        }];
        adguard.loadBalancer.servers = [{
          url = "http://localhost:5000";
        }];
      };
    };
  };
};

  systemd.services.traefik = {
    serviceConfig = {
      StateDirectory = "traefik";
      EnvironmentFile = "/home/mlflexer/repos/.dotfiles/hosts/rpi5/modules/traefik/.env";
    };
  };
  
}
