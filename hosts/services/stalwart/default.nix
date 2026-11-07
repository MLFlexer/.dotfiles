{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {
    stalwart.enable = lib.mkEnableOption "Enables stalwart";
    stalwart.port = lib.mkOption { default = 8009; };
    stalwart.domain = lib.mkOption { default = "mail.mlflexer.online"; };
    stalwart.cred_path = lib.mkOption {
      default = "/home/mlflexer/repos/.dotfiles/hosts/services/stalwart/creds";
      type = lib.types.path;
    };
  };

  config = lib.mkIf config.stalwart.enable {
    users.users.stalwart-mail.extraGroups = [
      "acme"
    ];

    systemd.services.stalwart-mail.environment.STALWART_RECOVERY_ADMIN = "admin:FuckingWorkPls123";
    systemd.services.stalwart-mail = {
      serviceConfig = {
        SupplementaryGroups = [
          "acme"
        ];

        ReadOnlyPaths = [
          "/var/lib/acme/mlflexer.online"
        ];
      };
    };

    services.stalwart-mail = {
      enable = true;
      openFirewall = true;

      credentials = {
        user_admin_password = "/run/keys/stalwart_admin_password";
      };

      settings = {

        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/keys/stalwart_admin_password}%";
        };

        directory.internal = {
          type = "internal";
        };

        authentication.directory = "internal";
        session.management.permissions = {
          admin = [ "all" ];
        };

        certificate.default = {
          cert = "file:///var/lib/acme/mlflexer.online/fullchain.pem";
          private-key = "file:///var/lib/acme/mlflexer.online/key.pem";
        };

        server = {
          hostname = config.stalwart.domain;
          domain = "mlflexer.online";
          listener = {
            management = {
              bind = [ "127.0.0.1:${toString config.stalwart.port}" ];
              protocol = "http";
              headers.trusted-networks = [ "127.0.0.1/32" ];
            };

            smtp = {
              bind = [ "[::]:25" ];
              protocol = "smtp";
            };
            submission = {
              bind = [ "[::]:587" ];
              protocol = "smtp";
            };
            imaps = {
              bind = [ "[::]:993" ];
              protocol = "imap";
              tls.implicit = true;
            };
          };
        };
      };
    };

  };
}
