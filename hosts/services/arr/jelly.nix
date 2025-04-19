{ lib, config, pkgs, ... }: {

  options = {
    arr.jelly.enable = lib.mkEnableOption "Enables jellyfin and jellyseerr";
    arr.jellyfin.domain = lib.mkOption { default = "stream.mlflexer.online"; };
    arr.jellyseerr.domain =
      lib.mkOption { default = "request.mlflexer.online"; };
    arr.jellyfin.dataDir =
      lib.mkOption { default = "${config.arr.data_dir}/jellyfin"; };
  };

  config = lib.mkIf config.arr.jelly.enable {

    services.jellyfin = {
      enable = true;
      group = config.arr.group;
      dataDir = config.arr.jellyfin.dataDir;
    };

    services.jellyseerr = {
      enable = true;
      openFirewall = true;
    };
  };
}
