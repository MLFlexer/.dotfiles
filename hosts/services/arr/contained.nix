{ lib, config, pkgs, ... }: {

  options = {
    arr.container = {
      enable = lib.mkEnableOption "Enables arr container";
      container_name = lib.mkOption { default = "arr"; };
      mullvad_config = lib.mkOption {
        type = lib.types.path;
        default = builtins.toPath ./mullvad.conf;
        # "/home/mlflexer/repos/.dotfiles/hosts/services/arr/mullvad.conf";
      };
      radarr_dir = lib.mkOption { default = "${config.arr.data_dir}/radarr"; };
      sonarr_dir = lib.mkOption { default = "${config.arr.data_dir}/sonarr"; };
      torrent_dir =
        lib.mkOption { default = "${config.arr.data_dir}/qbittorrent"; };
      torrent_port = lib.mkOption { default = 8173; };
      local_ip = lib.mkOption { default = "192.168.100.1"; };
      host_ip = lib.mkOption { default = "192.168.100.2"; };

      mullvad_ip = lib.mkOption { default = "45.129.56.67"; };
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
        networking.firewall.enable = false;
        networking.nftables = {
          enable = true;
          tables = {
            filter = {
              family = "inet";
              content = ''
                chain input {
                  type filter hook input priority 0; policy drop;
                  
                  # Localhost -> Container
                  iifname "lo" accept

                  # Accept replies to connections we initiated
                  ct state { established, related } accept
                  
                  # Host/LAN -> Container
                  ip saddr { ${config.arr.container.host_ip}, 192.168.0.0/24 } accept

                  # VPN -> Container
                  iifname "wg-mullvad" accept

                  log prefix "INPUT-DROP: " level warn
                  drop
                }

                chain output {
                  type filter hook output priority 0; policy drop;
                  
                  # Container -> Localhost
                  oifname "lo" accept

                  # Allow replies from remote to our packets
                  ct state { established, related } accept
                  
                  # Container -> Host/LAN
                  ip daddr { ${config.arr.container.host_ip}, 192.168.0.0/24 } accept

                  # Wireguard Handshake
                  # Container -> mullvad
                  ip daddr {${config.arr.container.mullvad_ip}} udp dport 51820 oifname "eth0" accept

                  # Container -> VPN
                  oifname "wg-mullvad" accept
                  
                  log prefix "OUTPUT-DROP: " level warn                  
                  reject
                }

                chain forward {
                  type filter hook forward priority 0; policy drop;

                  ct state { established, related } accept
                  # Container <-> VPN
                  iifname "wg-mullvad" accept
                  oifname "wg-mullvad" accept
                  drop
                }
              '';
            };
          };
        };

        # Mullvad
        # environment.etc."wg-mullvad.conf".source =
        # builtins.readFile config.arr.container.mullvad_config;
        # config.arr.container.mullvad_config;

        # The mullvad config must be placed in /mnt/arr/wg-mullvad.conf on the host
        networking.wg-quick.interfaces.wg-mullvad = {
          configFile = "${config.arr.data_dir}/wg-mullvad.conf";
          autostart = true;
        };
      };
    };
  };
}
