{ inputs, ... }:
{
  rpi5 = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [ 
      inputs.raspberry-pi-nix.nixosModules.raspberry-pi 
      ./configuration.nix
    ];
  };
}
