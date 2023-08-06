{
  description = "Home Manager configuration of mlflexer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database.url = "github:Mic92/nix-index-database"; # for comma integration
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs"; # for comma integration
  };

  outputs = { nixpkgs, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations.mlflexer = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nix-index-database.hmModules.nix-index # for comma integration
          ./home.nix
          ./sym_conf.nix
        ];
      };
    };
}
