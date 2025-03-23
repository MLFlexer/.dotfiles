{ lib, config, pkgs, ... }: {

  options = {
    arr.container = {
      enable = lib.mkEnableOption "Enables arr container";
      container_name = lib.mkOption { default = "arr"; };
      mullvad_config = lib.mkOption {
        default =
          "/home/mlflexer/repos/.dotfiles/hosts/services/arr/mullvad.conf";
      };
      radarr_dir = lib.mkOption { default = "${config.arr.data_dir}/radarr"; };
      sonarr_dir = lib.mkOption { default = "${config.arr.data_dir}/sonarr"; };
      torrent_dir =
        lib.mkOption { default = "${config.arr.data_dir}/qbittorrent"; };
      torrent_port = lib.mkOption { default = 8173; };
      local_ip = lib.mkOption { default = "192.168.100.1"; };
      host_ip = lib.mkOption { default = "192.168.100.2"; };
      host_mount = lib.mkOption { default = "/mnt/arr"; };
      external_interface =
        lib.mkOption { default = "end0"; }; # WARN: remember to set this
    };
  };

  config = lib.mkIf config.arr.container.enable {
    # https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
    networking.nat.enable = true;
    networking.nat.internalInterfaces =
      [ "ve-${config.arr.container.container_name}" ];
    networking.nat.externalInterface = config.arr.container.external_interface;

    containers.${config.arr.container.container_name} = {

      autoStart = true;

      privateNetwork = true;
      hostAddress = config.arr.container.host_ip;
      localAddress = config.arr.container.local_ip;

      bindMounts = {
        ${config.arr.data_dir} = {
          hostPath = config.arr.container.host_mount;
          isReadOnly = false;
        };
      };

      config = { ... }: {
        networking.nftables = {
          enable = true;
          tables = {
            filter = {
              family = "inet";
              content = ''
                chain input {
                  type filter hook input priority 0; policy drop;
                  
                  # Base allowances
                  ct state { established, related } accept
                  iifname "lo" accept
                  
                  # Allow host and LAN
                  ip saddr { ${config.arr.container.host_ip}, 192.168.0.0/24 } accept

                  # Allow VPN interface traffic
                  iifname "wg-mullvad" accept
                  
                  # Final drop (explicit for clarity)
                  log prefix "INPUT-DROP: " level warn
                  drop
                }

                chain output {
                  type filter hook output priority 0; policy drop;
                  
                  # Base allowances
                  ct state { established, related } accept
                  oifname "lo" accept
                  
                  # VPN traffic allowance
                  oifname "wg-mullvad" accept
                  
                  # Host/LAN fallback
                  ip daddr { ${config.arr.container.host_ip}, 192.168.0.0/24 } accept

                  udp dport 53 accept # DNS port
                  tcp dport 53 accept # DNS port
                  udp dport 51820 accept # mullvad port
                  
                  # Final drop
                  log prefix "OUTPUT-DROP: " level warn                  
                  drop
                }

                chain forward {
                  type filter hook forward priority 0; policy drop;
                  ct state { established, related } accept
                  iifname "wg-mullvad" accept
                  oifname "wg-mullvad" accept
                }
              '';
            };
          };
        };
        networking.firewall.enable = false;

        # Mullvad
        environment.etc."wg-mullvad.conf".text =
          builtins.readFile config.arr.container.mullvad_config;

        networking.wg-quick.interfaces.wg-mullvad = {
          configFile = "/etc/wg-mullvad.conf";
          autostart = true;
        };

        system.activationScripts.setDataPermissions = ''
          chown -R root:${config.arr.group} ${config.arr.data_dir}
          chmod -R 770 ${config.arr.data_dir}

          mkdir -p ${config.arr.container.radarr_dir}
          chown -R radarr:${config.arr.group} ${config.arr.container.radarr_dir}
          chmod -R 770 ${config.arr.container.radarr_dir}

          mkdir -p ${config.arr.container.sonarr_dir}
          chown -R sonarr:${config.arr.group} ${config.arr.container.sonarr_dir}
          chmod -R 770 ${config.arr.container.sonarr_dir}
           
          mkdir -p ${config.arr.container.torrent_dir}
          chown -R qbittorrent:${config.arr.group} ${config.arr.container.torrent_dir}
          chmod -R 770 ${config.arr.container.torrent_dir}
        '';

        # qbittorrent
        # systemd.services.qbittorrent = {
        #   after = [ "network.target" ];
        #   description = "Qbittorrent Web";
        #   wantedBy = [ "multi-user.target" ];
        #   path = [ pkgs.qbittorrent-nox ];
        #   serviceConfig = {
        #     ExecStart = ''
        #       ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${
        #         toString config.arr.container.torrent_port
        #       } --profile=${config.arr.container.torrent_dir}
        #     '';
        #     User = "qbittorrent";
        #     Group = config.arr.group;
        #     MemoryMax = "4G";
        #     Restart = "always";
        #   };
        # };

        # users.users.qbittorrent = {
        #   isSystemUser = true;
        #   description = "User for running qbittorrent";
        #   group = config.arr.group;
        # };

        networking.firewall.allowedTCPPorts =
          [ config.arr.container.torrent_port ];

        # https://github.com/averyanalex/dotfiles/blob/e1c167cf09402b35218780e62c8a455a24d231b6/profiles/server/qbit.nix#L6
        users.groups.${config.arr.group} = { name = config.arr.group; };

        services.prowlarr = {
          enable = false;
          openFirewall = true;
        };

        services.radarr = {
          enable = true;
          group = config.arr.group;
          openFirewall = true;
          dataDir = config.arr.container.radarr_dir;
        };

        services.sonarr = {
          enable = true;
          group = config.arr.group;
          openFirewall = true;
          dataDir = config.arr.container.sonarr_dir;
        };

        services.bazarr = {
          enable = false;
          group = config.arr.group;
        };

        services.lidarr = {
          enable = false;
          group = config.arr.group;
          # dataDir = "";
        };

        services.readarr = {
          enable = false;
          group = config.arr.group;
          # dataDir = "";
        };
      };
    };
  };
}
