{ lib, config, pkgs,... }:
let
  keyFile = "/run/livekit.key";
  in
 {

  options = {
    matrix.enable = lib.mkEnableOption "Enables matrix";
    matrix.port = lib.mkOption { default = 8008; };
    matrix.domain = lib.mkOption { default = "matrix.mlflexer.online"; };
    # matrix.livekit.domain = lib.mkOption { default = "livekit.mlflexer.online"; };
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
        server_name = "mlflexer.online";
        public_baseurl = "https://${config.matrix.domain}";
        database.name = "sqlite3";

        listeners = [
          {
            port = config.matrix.port;
            bind_addresses = ["127.0.0.1"];
            type = "http";
            tls = false;
            x_forwarded = true;
            resources = [
              {
                names = ["client" "federation"];
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
      before = [ "lk-jwt-service.service" "livekit.service" ];
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ livekit coreutils gawk ];
      script = ''
        echo "Key missing, generating key"
        echo "lk-jwt-service: $(livekit-server generate-keys | tail -1 | awk '{print $3}')" > "${keyFile}"
        chmod 640 "${keyFile}"
        chown livekit:lk-jwt-service "${keyFile}"
      '';
      serviceConfig.Type = "oneshot";
      unitConfig.ConditionPathExists = "!${keyFile}";
    };

  systemd.services.lk-jwt-service.environment.LIVEKIT_FULL_ACCESS_HOMESERVERS = config.matrix.domain;



  # MAUTRIX ------------------------------

  # services.mautrix-discord = {
  #   enable = true;
  #   dataDir = "/mnt/usbdrive2/mautrix/discord";
  # };



  
  };
}

