# NOTE: Use mullvad socks5 proxy for all services
# IP: 10.64.0.1
# PORT: 1080

{ inputs, pkgs, ... }:
let
  container_name = "arr";
  mullvad_config =
    "/home/mlflexer/repos/.dotfiles/hosts/rpi5/modules/arr/mullvad.conf";
  jellyfin_dir = "/data/jellyfin";
  radarr_dir = "/data/radarr";
  sonarr_dir = "/data/sonarr";
  torrent_port = 8173;
  torrent_dir = "/data/qbittorrent";
in {
  users.groups.mediagroup = { name = "mediagroup"; };
  services.jellyfin = {
    enable = true;
    group = "mediagroup";
    dataDir = jellyfin_dir;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  system.activationScripts.setDataPermissions = ''
    mkdir -p /mnt/mullvad
    mkdir -p /data/mullvad
    mkdir -p /data/media/movies
    mkdir -p /data/media/shows

    mkdir -p /data/downloads/movies
    mkdir -p /data/downloads/shows

    chown -R root:mediagroup /data
    chmod -R 770 /data

    mkdir -p ${jellyfin_dir}
    chown -R jellyfin:mediagroup ${jellyfin_dir}
    chmod -R 770 ${jellyfin_dir}
  '';

  # https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-${container_name}" ];
  networking.nat.externalInterface = "enp4s0";

  containers."${container_name}" = {
    autoStart = true;

    privateNetwork = true;
    hostAddress = "192.168.100.2";
    localAddress = "192.168.100.1";

    bindMounts = {
      "/data" = {
        hostPath = "/mnt/mullvad";
        isReadOnly = false;
      };
    };

    config = { ... }: {
      # Mullvad
      environment.etc."mullvad.conf".text = builtins.readFile mullvad_config;

      networking.wg-quick.interfaces.wg-mullvad = {
        configFile = "/etc/mullvad.conf";
        autostart = true;
      };

      # qbittorrent
      systemd.services.qbittorrent = {
        after = [ "network.target" ];
        description = "Qbittorrent Web";
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.qbittorrent-nox ];
        serviceConfig = {
          ExecStart = ''
            ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=${
              toString torrent_port
            } --profile=${torrent_dir}
          '';
          User = "qbittorrent";
          Group = "mediagroup";
          MemoryMax = "4G";
          Restart = "always";
        };
      };

      users.users.qbittorrent = {
        isSystemUser = true;
        description = "User for running qbittorrent";
        group = "mediagroup";
      };

      networking.firewall.allowedTCPPorts = [ torrent_port ];

      # https://github.com/averyanalex/dotfiles/blob/e1c167cf09402b35218780e62c8a455a24d231b6/profiles/server/qbit.nix#L6

      users.groups.mediagroup = { name = "mediagroup"; };

      system.activationScripts.setDataPermissions = ''
        # chown -R root:mediagroup /data/mullvad
        # chmod -R 770 /data

        mkdir -p ${radarr_dir}
        chown -R radarr:mediagroup ${radarr_dir}
        chmod -R 770 ${radarr_dir}

        mkdir -p ${sonarr_dir}
        chown -R sonarr:mediagroup ${sonarr_dir}
        chmod -R 770 ${sonarr_dir}
         
        mkdir -p ${torrent_dir}
        chown -R qbittorrent:mediagroup ${torrent_dir}
        chmod -R 770 ${torrent_dir}
      '';

      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };

      services.radarr = {
        enable = true;
        group = "mediagroup";
        openFirewall = true;
        dataDir = radarr_dir;
      };

      services.sonarr = {
        enable = true;
        group = "mediagroup";
        openFirewall = true;
        dataDir = sonarr_dir;
      };

      services.bazarr = {
        enable = false;
        group = "mediagroup";
      };

      services.lidarr = {
        enable = false;
        group = "mediagroup";
        # dataDir = "";
      };

      services.readarr = {
        enable = false;
        group = "mediagroup";
        # dataDir = "";
      };
    };
  };

}
