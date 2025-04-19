{ pkgs, config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.blacklistedKernelModules = [ "elan_i2c" ]; # to enable touchpad

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0c204fdf-9af9-42da-83f0-66df519876a0";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/669D-5F33";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/cb09ce52-0f1e-4bc2-96e1-b2a407e57b97"; }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages_5.clr.icd
    rocmPackages_5.clr
    rocmPackages_5.rocminfo
    rocmPackages_5.rocm-runtime
  ];
}
