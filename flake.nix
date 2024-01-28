{
  description = "Nix configuration flake for NixOS and Home-Manager";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    ollama-pkgs.url = "github:elohmeier/nixpkgs";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

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

  outputs = { nixpkgs, nixpkgs-unstable, flake-utils, home-manager, nix-index-database, ollama-pkgs, neovim-nightly, ... } @ inputs:
    {
      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs nixpkgs-unstable inputs;
        }
      );

      homeConfigurations = (
        import ./home-manager {
          inherit nixpkgs nixpkgs-unstable home-manager nix-index-database ollama-pkgs neovim-nightly;
        }
      );
    };
}
