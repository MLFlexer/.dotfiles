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

in
lib.nixosSystem {
  inherit system;
  nixpkgs = inputs.nixpkgs;  # ADD THIS LINE - force it to use YOUR nixpkgs
  specialArgs = {
    inherit
      unstable
      user
      nixos-raspberrypi
      inputs
      ;
  };
  modules = [
    # raspberry-pi-nix.nixosModules.raspberry-pi
    # raspberry-pi-nix.nixosModules.sd-image

    {
      hardware.raspberry-pi.config = {
        all = {
          # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
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
    (
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        kernelBundle = pkgs.linuxAndFirmware.v6_12_25;
      in
      {
        imports = with nixos-raspberrypi.nixosModules; [
          trusted-nix-caches
          # nixpkgs-rpi
          # nixos-raspberrypi.lib.inject-overlays
        ];
        boot = {
          loader.raspberryPi.firmwarePackage = kernelBundle.raspberrypifw;
          kernelPackages = kernelBundle.linuxPackages_rpi5;
        };

        nixpkgs.overlays = lib.mkAfter [
          (self: super: {
            # This is used in (modulesPath + "/hardware/all-firmware.nix") when at least
            # enableRedistributableFirmware is enabled
            # I know no easier way to override this package
            inherit (kernelBundle) raspberrypiWirelessFirmware;
            # Some derivations want to use it as an input,
            # e.g. raspberrypi-dtbs, omxplayer, sd-image-* modules
            inherit (kernelBundle) raspberrypifw;
          })
        ];
      }
    )
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    # inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
    ./configuration.nix

    ../services
    {
      system.stateVersion = "25.11";
      home-assistant.enable = true;
      adguardhome.enable = true;
      nextcloud.enable = true;
      traefik.enable = false;
      nginx.enable = true;
      wireguard.enable = true;
      immich.enable = false;
      matrix.enable = true;

      arr.jelly.enable = true;
      arr.enable = true;
      arr.container.enable = true;
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
