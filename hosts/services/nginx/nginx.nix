{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    nginx.enable = lib.mkEnableOption "Enables nginx (migrated from nginx)";
    nginx.env_file = lib.mkOption {
      default = "/home/mlflexer/repos/.dotfiles/hosts/services/nginx/.env";
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.nginx.enable {

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    security.acme = {
      acceptTerms = true;
      defaults.email = "malthemlarsen@gmail.com";

      certs."mlflexer.online" = {
        dnsProvider = "cloudflare";
        credentialsFile = config.nginx.env_file;
        group = "nginx";
        extraDomainNames = [
          config.arr.jellyfin.domain
          config.arr.jellyseerr.domain
          config.home-assistant.domain
          config.adguardhome.domain
          config.nextcloud.domain
          config.matrix.domain
          config.immich.domain
          "discord.bridge.mlflexer.online"
          "instagram.bridge.mlflexer.online"
          "messenger.bridge.mlflexer.online"
        ];
      };
    };

    services.nginx = {
      enable = true;

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "mlflexer.online" = {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations = {
          };
        };

        "${config.nextcloud.domain}" = lib.mkIf config.nextcloud.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
        };

        "${config.matrix.domain}" = lib.mkIf config.matrix.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString config.matrix.port}";
            };

            "^~ /livekit/jwt/" = {
              priority = 400;
              proxyPass = "http://[::1]:${toString config.services.lk-jwt-service.port}/";
            };

            "^~ /livekit/sfu/" = {
              priority = 400;
              proxyPass = "http://[::1]:${toString config.services.livekit.settings.port}/";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_buffering off;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "upgrade";
              '';
            };
          };

        };

        "discord.bridge.mlflexer.online" = {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:29334";
            };
            "= /.well-known/matrix/server".extraConfig = ''
              add_header Content-Type application/json;
                return 200 '${builtins.toJSON { "m.server" = "discord.bridge.mlflexer.online:443"; }}';
            '';
          };
        };

        "messenger.bridge.mlflexer.online" = {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:29319";
            };
            "= /.well-known/matrix/server".extraConfig = ''
              add_header Content-Type application/json;
                return 200 '${builtins.toJSON { "m.server" = "messenger.bridge.mlflexer.online:443"; }}';
            '';
          };
        };

        "instagram.bridge.mlflexer.online" = {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:29320";
            };
            "= /.well-known/matrix/server".extraConfig = ''
              add_header Content-Type application/json;
                return 200 '${builtins.toJSON { "m.server" = "instagram.bridge.mlflexer.online:443"; }}';
            '';
          };
        };

        "${config.arr.jellyfin.domain}" = lib.mkIf config.arr.jelly.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/".proxyPass = "http://localhost:8096";
        };

        "${config.arr.jellyseerr.domain}" = lib.mkIf config.arr.jelly.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/".proxyPass = "http://localhost:5055";
        };

        "${config.home-assistant.domain}" = lib.mkIf config.home-assistant.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/".proxyPass = "http://localhost:${toString config.home-assistant.port}";
          locations."/api/websocket" = {
            proxyPass = "http://localhost:${toString config.home-assistant.port}/api/websocket";
            proxyWebsockets = true;
          };
        };

        "${config.adguardhome.domain}" = lib.mkIf config.adguardhome.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/".proxyPass = "http://localhost:${toString config.adguardhome.port}";
        };

        "${config.immich.domain}" = lib.mkIf config.immich.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/" = {
            proxyPass = "http://localhost:${toString config.immich.port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
            extraConfig = ''
              client_max_body_size 50000M;
              proxy_read_timeout   600s;
              proxy_send_timeout   600s;
              send_timeout         600s;
            '';
          };
        };

        "prowlarr.local" = lib.mkIf config.arr.container.enable {
          addSSL = false;
          locations."/".proxyPass = "http://${config.arr.container.local_ip}:9696";
        };

        "sonarr.local" = lib.mkIf config.arr.container.enable {
          addSSL = false;
          locations."/".proxyPass = "http://${config.arr.container.local_ip}:8989";
        };

        "radarr.local" = lib.mkIf config.arr.container.enable {
          addSSL = false;
          locations."/".proxyPass = "http://${config.arr.container.local_ip}:7878";
        };

        "bazarr.local" = lib.mkIf config.arr.container.enable {
          addSSL = false;
          locations."/".proxyPass = "http://${config.arr.container.local_ip}:6767";
        };

        "torrent.local" = lib.mkIf config.arr.container.enable {
          addSSL = false;
          locations."/".proxyPass = "http://${config.arr.container.local_ip}:8173";
        };
      };
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
