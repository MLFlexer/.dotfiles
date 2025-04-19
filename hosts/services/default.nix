{ lib, ... }: {

  options = { user = lib.mkOption { default = "mlflexer"; }; };

  imports = [
    ./home-assistant.nix
    ./searxng.nix
    ./adguard.nix
    ./nextcloud.nix
    ./arr
    ./traefik
    # ./kanata
  ];

}
