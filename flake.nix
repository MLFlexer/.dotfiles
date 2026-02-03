{
  description = "Nix configuration flake for NixOS and Home-Manager";

  # for raspberry pi
  nixConfig = {
    extra-substituters = [ "https://nixos-raspberrypi.cachix.org" ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://mlflexer.cachix.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "mlflexer.cachix.org-1:9tD5WIKif3nAUHHq6wTYFlg1bMq1z5uF0+h5UqICsQQ="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    trusted-users = [
      "root"
      "mlflexer"
    ];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # raspberry-pi-nix = {
    #   url = "github:tstat/raspberry-pi-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    helix-editor = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window manager stuff
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # dms-cli = {
    #   url = "github:AvengeMedia/danklinux";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.dgop.follows = "dgop";
      # inputs.dms-cli.follows = "dms-cli";
    };

    # comma integration
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    {
      nixosConfigurations = (import ./hosts { inherit inputs; });
      homeConfigurations = (import ./home-manager { inherit inputs; });
    };
}
