{ config, lib }:

let
  core_services = lib.filter (s: s.enabled) [
    {
      enabled = config.immich.enable;
      title = "Immich";
      url = "https://${config.immich.domain}/";
      icon = "sh:immich";
    }
    {
      enabled = config.adguardhome.enable;
      title = "AdGuard Home";
      url = "https://${config.adguardhome.domain}/";
      icon = "sh:adguard-home";
    }
    {
      enabled = config.home-assistant.enable;
      title = "Home-assistant";
      url = "https://${config.home-assistant.domain}/";
      icon = "sh:home-assistant";
    }
    {
      enabled = config.matrix.enable;
      title = "Matrix";
      url = "https://${config.matrix.domain}/";
      icon = "sh:matrix";
    }
    {
      enabled = config.nextcloud.enable;
      title = "Nextcloud";
      url = "https://${config.nextcloud.domain}/";
      icon = "sh:nextcloud";
    }
  ];
  arr_services = lib.filter (s: s.enabled) [
    {
      enabled = config.arr.jelly.enable;
      title = "Jellyfin";
      url = "https://${config.arr.jellyfin.domain}/";
      icon = "sh:jellyfin";
    }
    {
      enabled = config.arr.enable;
      title = "Jellyseerr";
      url = "https://${config.arr.jellyseerr.domain}/";
      icon = "sh:jellyseerr";
    }
    {
      enabled = config.arr.container.enable;
      title = "qBittorrent";
      url = "http://torrent.local";
      icon = "sh:qbittorrent";
    }
    {
      enabled = config.arr.container.enable;
      title = "Sonarr";
      url = "http://sonarr.local";
      icon = "sh:sonarr";
    }
    {
      enabled = config.arr.container.enable;
      title = "Radarr";
      url = "http://radarr.local";
      icon = "sh:radarr";
    }
    {
      enabled = config.arr.container.enable;
      title = "Prowlarr";
      url = "http://prowlarr.local"; # Adjust domain/IP as needed
      icon = "sh:prowlarr";
    }
    {
      enabled = config.arr.container.enable;
      title = "Bazarr";
      url = "http://bazarr.local";
      icon = "sh:bazarr";
    }
    # {
    #   enabled = config.arr.container.enable;
    #   title = "Lidarr";
    #   url = "http://lidarr.local";
    #   icon = "sh:lidarr";
    # }
    # {
    #   enabled = config.arr.container.enable;
    #   title = "Readarr";
    #   url = "http://readarr.local";
    #   icon = "sh:readarr";
    # }
  ];

  # 2. Clean the sites for Glance
  core = map (s: builtins.removeAttrs s [ "enabled" ]) core_services;
  arr = map (s: builtins.removeAttrs s [ "enabled" ]) arr_services;

in
# 3. Return only the widget object
{
  core_stack = {
    type = "monitor";
    cache = "1m";
    title = "Services";
    sites = core;
  };
  arr_stack = {
    type = "monitor";
    cache = "1m";
    title = "Arr Stack";
    sites = arr;
  };
  adguard_status = {
    type = "dns-stats";
    service = "adguard";
    url = "https://${config.adguardhome.domain}/";
    username = "admin";
    password = "\${ADGUARD_PASSWORD}";
  };
}
