{
  description = "Nix configuration flake for NixOS and Home-Manager";

  # for raspberry pi
  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "mlflexer"];
  };

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # for raspberry pi
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:tstat/raspberry-pi-nix";
    raspberry-pi-nix.inputs.nixpkgs.follows = "nixpkgs";

    # for wsl
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # comma integration
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... }@inputs: {
    nixosConfigurations = (import ./hosts { inherit inputs; });

    homeConfigurations = (import ./home-manager { inherit inputs; });
  };
}
