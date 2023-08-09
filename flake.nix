{
  description = "Nix configuration flake for NixOS and Home-Manager";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database"; # for comma integration
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs"; # for comma integration
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, nix-index-database, ... }:
    let
      lib = nixpkgs.lib;

    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit lib nixpkgs nixpkgs-unstable home-manager;
        }
      );

      homeConfigurations = (
        import ./home-manager {
          inherit lib nixpkgs nixpkgs-unstable home-manager nix-index-database;
        }
      );
    };
}
