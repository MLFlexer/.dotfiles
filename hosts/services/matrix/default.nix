{
  lib,
  config,
  pkgs,
  ...
}:
let
  keyFile = "/run/livekit.key";
in
{

  options = {
    matrix.enable = lib.mkEnableOption "Enables matrix";
    matrix.port = lib.mkOption { default = 8008; };
    matrix.domain = lib.mkOption { default = "matrix.mlflexer.online"; };
    matrix.registration_secret = lib.mkOption {
      default = "/home/mlflexer/repos/.dotfiles/hosts/services/matrix/.reg_secret";
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.matrix.enable {

    services.matrix-synapse = {
      enable = true;
      dataDir = "/mnt/usbdrive2/matrix-synapse";
      settings = {
        server_name = config.matrix.domain;
        public_baseurl = "https://${config.matrix.domain}";
        enable_authenticated_media = false;
        dynamic_thumbnails = true;

        federation_verify_certificates = true;
        default_identity_server = "https://vector.im";

        listeners = [
          {
            port = config.matrix.port;
            bind_addresses = [ "127.0.0.1" ];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                names = [
                  "client"
                  "federation"
                  "media"
                ];
                compress = true;
              }
            ];
          }
        ];

        max_upload_size_mib = 100;
        url_preview_enabled = true;
        enable_registration = false;
        enable_metrics = false;
        # registration_shared_secret_path = config.matrix.registration_secret;

        trusted_key_servers = [
          {
            server_name = "matrix.org";
          }
        ];
        # Enable the features that make calls fast
        experimental_features = {
          msc3266_enabled = true; # Room summary for knocking
          msc4222_enabled = true; # Fixed sync for calls
        };

        extra_well_known_client_content = {

          "org.matrix.msc4143.rtc_foci" = [
            {
              "type" = "livekit";
              "livekit_service_url" = "https://${config.matrix.domain}/livekit/jwt";
              "livekit_alias" = config.matrix.domain;
            }
          ];
          "org.matrix.msc3575.proxy" = {
            "url" = "https://${config.matrix.domain}";
          };

        };

        serve_server_wellknown = true;
        matrix_rtc.transports = [
          {
            type = "livekit";
            livekit_service_url = "https://${config.matrix.domain}/livekit/jwt";
          }

        ];

      };
    };

    services.livekit = {
      enable = true;
      openFirewall = true;
      settings.room.auto_create = true;
      settings.rtc = {
        use_external_ip = false;
      };
      inherit keyFile;
    };

    services.lk-jwt-service = {
      enable = true;
      livekitUrl = "wss://${config.matrix.domain}/livekit/sfu";
      inherit keyFile;
    };

    systemd.services.livekit-key = {
      before = [
        "lk-jwt-service.service"
        "livekit.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        livekit
        coreutils
        gawk
      ];
      script = ''
        echo "Key missing, generating key"
        echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${keyFile}"
        # chmod 640 "${keyFile}"
        # chown livekit:lk-jwt-service "${keyFile}"
      '';
      serviceConfig.Type = "oneshot";
      unitConfig.ConditionPathExists = "!${keyFile}";
    };

    systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = config.matrix.domain;

    # MAUTRIX ------------------------------
    nixpkgs.config.permittedInsecurePackages = [
      "olm-3.2.16"
    ];

    services.postgresql = {
      enable = true;
      ensureUsers = [
        {
          name = "mautrix-discord";
          ensureDBOwnership = true;
        }
        {
          name = "mautrix-meta-messenger";
          ensureDBOwnership = true;
        }
        {
          name = "mautrix-meta-instagram";
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [
        "mautrix-discord"
        "mautrix-meta-messenger"
        "mautrix-meta-instagram"
      ];
    };

    # Discord
    services.mautrix-discord = {
      enable = true;
      dataDir = "/mnt/usbdrive2/mautrix/discord";
      settings = {
        homeserver = {
          domain = config.matrix.domain;
          address = "https://${config.matrix.domain}";
        };
        # database = {
        #   type = "postgres";
        #   uri = "postgresql:///mautrix-discord?host=/var/run/postgresql";
        # };
        appservice = {
          database = {
            type = "postgres";
            uri = "postgresql:///mautrix-discord?host=/var/run/postgresql";
          };
        };
        bridge = {
          public_address = "https://discord.bridge.mlflexer.online";
          permissions = {
            "@mlflexer:${config.matrix.domain}" = "admin";
          };
          direct_media = {
            enabled = true;
            server_name = "discord.bridge.mlflexer.online"; # 29334
            allow_proxy = true;
          };
        };

      };
    };

    # Meta
    services.mautrix-meta = {
      instances = {
        messenger = {
          enable = true;
          settings = {
            homeserver = {
              domain = config.matrix.domain;
              address = "https://${config.matrix.domain}";
            };
            database = {
              type = "postgres";
              uri = "postgresql:///mautrix-meta-messenger?host=/var/run/postgresql";
            };
            appservice = {
              public_address = "https://messenger.bridge.mlflexer.online";
              id = "messenger";
              bot = {
                username = "Messenger";
              };
            };
            bridge = {
              permissions = {
                "@mlflexer:${config.matrix.domain}" = "admin";
              };
            };
            direct_media = {
              enabled = true;
              server_name = "messenger.bridge.mlflexer.online"; # 29319
              allow_proxy = true;
            };
            network.mode = "messenger";

          };

        };
        instagram = {
          enable = true;
          settings = {
            homeserver = {
              domain = config.matrix.domain;
              address = "https://${config.matrix.domain}";
            };
            database = {
              type = "postgres";
              uri = "postgresql:///mautrix-meta-instagram?host=/var/run/postgresql";
            };
            appservice = {
              public_address = "https://instagram.bridge.mlflexer.online";
              id = "instagram";
              bot = {
                username = "instagram";
              };
            };
            bridge = {
              permissions = {
                "@mlflexer:${config.matrix.domain}" = "admin";
              };
            };
            direct_media = {
              enabled = true;
              server_name = "instagram.bridge.mlflexer.online"; # 29320
              allow_proxy = true;
            };
            network.mode = "instagram";

          };

        };
      };

    };

  };
}
