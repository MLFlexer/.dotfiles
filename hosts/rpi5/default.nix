{ inputs, ... }:

let
  system = "aarch64-linux";
  user = "mlflexer";

  unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = inputs.nixos-raspberrypi.lib;

  nixos-raspberrypi = inputs.nixos-raspberrypi;

in lib.nixosSystem {
  inherit system;
  specialArgs = { inherit unstable user nixos-raspberrypi inputs; };
  modules = [
    # raspberry-pi-nix.nixosModules.raspberry-pi
    # raspberry-pi-nix.nixosModules.sd-image

    {
      hardware.raspberry-pi.config = {
        all =
          { # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
            # Base DTB parameters
            # https://github.com/raspberrypi/linux/blob/a1d3defcca200077e1e382fe049ca613d16efd2b/arch/arm/boot/dts/overlays/README#L132
            base-dt-params = {

              # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#enable-pcie
              pciex1 = {
                enable = true;
                value = "on";
              };
              # PCIe Gen 3.0
              # https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#pcie-gen-3-0
              pciex1_gen = {
                enable = true;
                value = "3";
              };

            };

          };
      };

      boot.initrd.kernelModules = [ "nvme" ];
    }
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    ./configuration.nix
    ../services
    {
      home-assistant.enable = true;
      adguardhome.enable = true;
      nextcloud.enable = true;
      traefik.enable = true;

      arr.jelly.enable = false;
      arr.enable = false;
      arr.container.enable = false;
    }

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        extraSpecialArgs = { inherit inputs system unstable; };
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${user} = ./home.nix;
      };
    }
  ];
}

