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

            nvme = {
              enable = true;
            };

            # bluetooth
            krnbt = {
              enable = true;
              value = "on";
            };

          };

          dt-overlays.vc4-kms-v3d.enable = false;
          # graphics.enable = false;

        };
      };

      boot.initrd.availableKernelModules = [
        "nvme"
        "pcie_brcmstb"
      ];

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
          # loader.raspberry-pi.firmwarePackage = kernelBundle.raspberrypifw;
          kernelPackages = kernelBundle.linuxPackages_rpi5;
        };
        boot.loader.raspberry-pi.firmwarePath = "/boot";
        boot.loader.raspberry-pi.bootloader = "kernel";
        boot.kernelParams = [
          "root=UUID=8b57d8e1-2422-44bd-bc49-38af5feb820b"
          "rootfstype=ext4"
          "rootwait"
        ];

        # boot.loader.grub.configurationLimit = 2;
        # nix.settings.auto-optimise-store = true;

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
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
    ./configuration.nix

    ../services
    {
      system.stateVersion = "25.11";

      nginx.enable = true;
      home-assistant.enable = true;
      adguardhome.enable = true;
      wireguard.enable = false;
      nextcloud.enable = false;
      immich.enable = true;
      matrix.enable = true;

      arr.jelly.enable = true;
      arr.enable = true;
      arr.container.enable = true;

      traefik.enable = false;
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
