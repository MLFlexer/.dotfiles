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
    };
  };

  config = lib.mkIf config.arr.container.enable {
    # https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
    networking.nat.enable = true;
    networking.nat.internalInterfaces =
      [ "ve-${config.arr.container.container_name}" ];
    networking.nat.externalInterface = "enp4s0";

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
        networking.firewall.enable = true;
        networking.firewall.extraCommands = ''
          # Set default policies to DROP
          iptables -P INPUT DROP
          iptables -P OUTPUT DROP
          iptables -P FORWARD DROP

          # INPUT Chain Rules
          # Allow loopback traffic 
          iptables -I INPUT -i lo -j ACCEPT           
          # Allow from config.arr.container.local_ip
          iptables -I INPUT -s ${config.arr.container.local_ip} -j ACCEPT
          # Allow from config.arr.container.host_ip
          iptables -I INPUT -s ${config.arr.container.host_ip} -j ACCEPT
          # Allow established
          iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 

          # OUTPUT Chain Rules (order matters!)
          # Allow establishing connection to VPN 
          iptables -I OUTPUT -d 45.129.56.67 -p udp --dport 51820 -j ACCEPT
          # Allow loopback first
          iptables -I OUTPUT -o lo -j ACCEPT           
          # Allow traffic to config.arr.container.local_ip
          iptables -I OUTPUT -d ${config.arr.container.local_ip} -j ACCEPT 
          # Allow traffic to config.arr.container.host_ip
          iptables -I OUTPUT -d ${config.arr.container.host_ip} -j ACCEPT 
          # Allow established
          iptables -A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
          # Allow traffic through VPN interface
          iptables -A OUTPUT -o wg-mullvad -j ACCEPT
        '';

        # Mullvad
        environment.etc."mullvad.conf".text =
          builtins.readFile config.arr.container.mullvad_config;

        networking.wg-quick.interfaces.wg-mullvad = {
          configFile = "/etc/mullvad.conf";
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
        systemd.services.qbittorrent = {
          after = [ "network.target" ];
          description = "Qbittorrent Web";
          wantedBy = [ "multi-user.target" ];
          path = [ pkgs.qbittorrent-nox ];
          serviceConfig = {
            ExecStart = ''
              ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${
                toString config.arr.container.torrent_port
              } --profile=${config.arr.container.torrent_dir}
            '';
            User = "qbittorrent";
            Group = config.arr.group;
            MemoryMax = "4G";
            Restart = "always";
          };
        };

        users.users.qbittorrent = {
          isSystemUser = true;
          description = "User for running qbittorrent";
          group = config.arr.group;
        };

        networking.firewall.allowedTCPPorts =
          [ config.arr.container.torrent_port ];

        # https://github.com/averyanalex/dotfiles/blob/e1c167cf09402b35218780e62c8a455a24d231b6/profiles/server/qbit.nix#L6
        users.groups.${config.arr.group} = { name = config.arr.group; };

        services.prowlarr = {
          enable = true;
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
