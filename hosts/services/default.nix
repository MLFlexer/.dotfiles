{ lib, ... }:
{

  options = {
    user = lib.mkOption { default = "mlflexer"; };
  };

  imports = [
    ./home-assistant.nix
    ./searxng
    ./filebrowser.nix
    ./stalwart
    ./mealie.nix
    ./adguard.nix
    ./freshrss
    ./nextcloud.nix
    ./matrix
    ./arr
    ./glance
    ./traefik
    ./nginx/nginx.nix
    ./immich.nix
    ./wireguard.nix
  ];

}
