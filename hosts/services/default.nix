{ lib, ... }: {

  options = { user = lib.mkOption { default = "mlflexer"; }; };

  imports = [
    ./home-assistant.nix
    ./searxng.nix
    ./adguard.nix
    ./nextcloud.nix
    ./matrix
    ./arr
    ./traefik
    ./nginx/nginx.nix
    ./immich.nix
    ./wireguard.nix
  ];

}
