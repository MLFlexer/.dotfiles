{
  description = "Nix configuration flake for NixOS and Home-Manager";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # comma integration
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { ... } @ inputs:
    {
      nixosConfigurations = (
        import ./hosts {
          inherit inputs;
        }
      );

      homeConfigurations = (
        import ./home-manager {
          inherit inputs;
        }
      );
    };
}
