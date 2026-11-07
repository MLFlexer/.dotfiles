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

    users.users.nginx.extraGroups = [ "acme" ];

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
          config.freshrss.domain
          "freshrss.mlflexer.online"
          config.immich.domain
          config.stalwart.domain
          config.glance.domain
          config.mealie.domain
          config.searx.domain
          config.filebrowser.domain
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

        "${config.stalwart.domain}" = lib.mkIf config.stalwart.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.stalwart.port}";
            proxyWebsockets = true;
          };

          locations."/admin" = {
            proxyPass = "http://127.0.0.1:${toString config.stalwart.port}";
            proxyWebsockets = true;
          };

        };

        "${config.nextcloud.domain}" = lib.mkIf config.nextcloud.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
        };

        "${config.searx.domain}" = lib.mkIf config.searx.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:${toString config.searx.port}";
          basicAuth = {
            mlflexer = "u*%J%4&LpV371x";
          };
        };

        "${config.freshrss.domain}" = lib.mkIf config.freshrss.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
        };

        "${config.filebrowser.domain}" = lib.mkIf config.filebrowser.enable {
          useACMEHost = "mlflexer.online";
          forceSSL = true;
          locations."/".proxyPass = "http://localhost:${toString config.filebrowser.port}";
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

        "${config.glance.domain}" = lib.mkIf config.glance.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/" = {
            proxyPass = "http://localhost:${toString config.glance.port}";
            extraConfig = ''
              proxy_buffering off;
              proxy_connect_timeout 60s;
              proxy_read_timeout 60s;
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

        "${config.mealie.domain}" = lib.mkIf config.mealie.enable {
          forceSSL = true;
          useACMEHost = "mlflexer.online";
          locations."/".proxyPass = "http://localhost:${toString config.mealie.port}";
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
        "openthread.local" = {
          addSSL = false;
          locations."/".proxyPass = "http://localhost:8082";
        };
      };
    };

    services.crowdsec-firewall-bouncer = {
      enable = true;

      # 1. Disable the failing auto-registration service
      registerBouncer.enable = false;

      # 2. Use the "secrets" option from your list to point to your key
      secrets.apiKeyPath = "/var/lib/crowdsec/bouncer_key";

      settings = {
        # 3. Explicitly point to your Local API (from your previous config)
        api_url = "http://127.0.0.1:8081";

        # 4. Use the nftables mode (standard for RPi/NixOS)
        # mode = "nftables";
      };
    };

    services.crowdsec = {
      enable = true;

      settings = {
        # This is the "API client section" the error was complaining about
        general.api = {
          client.credentials_path = "/var/lib/crowdsec/local_api_credentials.yaml";
          server = {
            enable = true;
            listen_uri = "127.0.0.1:8081"; # Note the port 8081 from your example
          };
        };

        # Explicit paths for the LAPI and CAPI credential files
        lapi.credentialsFile = "/var/lib/crowdsec/local_api_credentials.yaml";
        # capi.credentialsFile = "/var/lib/crowdsec/online_api_credentials.yaml";

        # console = {
        #   tokenFile = "/home/mlflexer/repos/.dotfiles/hosts/services/nginx/.crowdsec_token";
        # };
      };

      hub = {
        collections = [
          "crowdsecurity/linux"
          "crowdsecurity/nginx"
          "crowdsecurity/base-http-scenarios"
          "crowdsecurity/http-cve"
          "crowdsecurity/appsec-generic-rules"
          "crowdsecurity/nextcloud"
          "crowdsecurity/home-assistant"
          "LePresidente/jellyfin"
          "LePresidente/jellyseerr"
          "gauth-fr/immich"
          "LePresidente/adguardhome"
          "schiz0phr3ne/sonarr"
          "schiz0phr3ne/radarr"
          "schiz0phr3ne/prowlarr"
          "crowdsecurity/whitelist-good-actors"
        ];

        parsers = [
          "crowdsecurity/jellyfin-whitelist"
          "crowdsecurity/jellyseerr-whitelist"
        ];
      };

      localConfig = {
        acquisitions = [
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=nginx.service" ];
            labels.type = "nginx";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=jellyfin.service" ];
            labels.type = "jellyfin";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=home-assistant.service" ];
            labels.type = "home-assistant";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=immich-server.service" ];
            labels.type = "immich";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=adguardhome.service" ];
            labels.type = "adguardhome";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=phpfpm-nextcloud.service" ];
            labels.type = "nextcloud";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=sonarr.service" ];
            labels.type = "sonarr";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=radarr.service" ];
            labels.type = "radarr";
          }
          {
            source = "journalctl";
            journalctl_filter = [ "_SYSTEMD_UNIT=prowlarr.service" ];
            labels.type = "prowlarr";
          }
        ];
      };
    };

  };
}
