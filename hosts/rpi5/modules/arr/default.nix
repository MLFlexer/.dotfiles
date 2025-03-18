{ inputs, pkgs, ... }:
let
  jellyfin_dir = "/data/jellyfin";
  radarr_dir = "/data/radarr";
  sonarr_dir = "/data/sonarr";
in {
  # services.mullvad-vpn.enable = true;

  systemd.services.qbittorrent = {
    after = [ "network.target" ];
    description = "Qbittorrent Web";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.qbittorrent-nox ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8173
      '';
      User = "mlflexer";
      Group = "mediagroup";
      MemoryMax = "4G";
      Restart = "always";
    };
  };

  networking.firewall.interfaces."mlflexer".allowedTCPPorts = [ 8173 ];
  #https://github.com/averyanalex/dotfiles/blob/e1c167cf09402b35218780e62c8a455a24d231b6/profiles/server/qbit.nix#L6

  users.groups.mediagroup = { name = "mediagroup"; };
  system.activationScripts.setDataPermissions = ''
    mkdir -p /data/media/movies
    mkdir -p /data/media/shows

    mkdir -p /data/downloads/movies
    mkdir -p /data/downloads/shows

    chown -R root:mediagroup /data
    chmod -R 770 /data

    mkdir -p ${jellyfin_dir}
    chown -R jellyfin:mediagroup ${jellyfin_dir}
    chmod -R 770 ${jellyfin_dir}

    mkdir -p ${radarr_dir}
    chown -R radarr:mediagroup ${radarr_dir}
    chmod -R 770 ${radarr_dir}

    mkdir -p ${sonarr_dir}
    chown -R sonarr:mediagroup ${sonarr_dir}
    chmod -R 770 ${sonarr_dir}
  '';

  services.jellyfin = {
    enable = true;
    group = "mediagroup";
    dataDir = jellyfin_dir;
  };

  services.jellyseerr = {
    enable = true;
    openFirewall = true;
  };

  # services.flaresolverr = {
  #   enable = true;
  #   openFirewall = true;
  # };

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
    enable = true;
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

}
