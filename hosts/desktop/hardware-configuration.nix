{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "nvidia"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "egl-wayland"
    "nvidia_uvm"
    "nvidia_modeset"
    "libva-nvidia-driver"
    "nvidia_drm"
  ];
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4fa97e83-f840-4632-944d-fc38e32427ae";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A5C1-10EF";
    fsType = "vfat";
  };

  fileSystems."/sandisk" = {
    device = "/dev/disk/by-uuid/f431743a-286e-4cfe-b835-170f412cf0ad";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/f13185d5-ce2f-4be4-97e9-1b4f9514bbb4"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # https://github.com/CallMeCaleb94/KyniFlakes/blob/main/modules/nvidia.nix
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement = {
      enable = true;
      finegrained = false;
    };

    prime = { nvidiaBusId = "PCI:09:00.0"; };
  };
}
