{ pkgs, unstable, user, raspberry-pi-nix, ... }: {
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";

  users.users.root.initialPassword = "root";
  networking = {
    hostName = "rpi5";
    useDHCP = true;
    interfaces = { wlan0.useDHCP = true; };
    wireless = {
      enable = true;
      userControlled.enable = true;

      networks = { };
    };
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "${user}" ];

  users.users.${user} = {
    initialPassword = "root";
    isNormalUser = true;
    createHome = true;
    description = "${user} user.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "usbdrive2"
      "nextcloud"
      "hass"
      "jellyfin"
      "mediagroup"
    ];
    shell = pkgs.zsh;
    packages = (with pkgs; [
      cachix
      tmux
      btop
      # stable
    ]) ++ (with unstable; [ wezterm ]);

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdXjmV661jKgb8bOQ8MqpOlNTfRSo/AneI4KqJ6dhcf malthemlarsen@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARHveCo8QOYQzd4rUYdPR37iXMe6wW+XgUacnmJfkwN malthemlarsen@gmail.com"
    ];
  };

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [
    22
    # 25565
    # 3000
    # 4221
    # 
    8173
    443
    5000
    53
    6969
    80
    8000
    8080
    8096
    8920
    # 8888
  ];
  networking.firewall.allowedUDPPortRanges = [
    # {
    #   from = 2456;
    #   to = 2457;
    # } # Valheim
    {
      from = 1900;
      to = 1900;
    }
    {
      from = 7359;
      to = 7359;
    }
  ];

  fileSystems."/" = {
    device = "/dev/nvme0n1p2";
    fsType = "ext4";
  };

  fileSystems = {
    "/mnt/usbdrive2" = {
      device = "/dev/disk/by-uuid/6def3262-e479-4b32-b6f1-14a19989c546";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };
  };

  users.groups.usbdrive2 = { name = "usbdrive2"; };
  systemd.tmpfiles.rules = [ "d /mnt/usbdrive2 0755 usbdrive2 usbdrive2 -" ];

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "mlflexer" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    bluez
    bluez-tools
    unzip
    raspberrypi-eeprom
    rpi-imager
    yazi
  ];
  system.stateVersion = "24.11";
  # raspberry-pi-nix = {
  #   kernel-version = "v6_6_51";
  #   board = "bcm2712";
  #   libcamera-overlay = { enable = false; };
  #   uboot.enable = false;
  # };
  # # raspberry-pi-nix.pin-inputs = { enable = true; };
  # hardware = {
  #   bluetooth.enable = true;
  #   raspberry-pi = {
  #     config = {
  #       all = {
  #         base-dt-params = {
  #           nvme.enable = true;
  #           pciex1_gen = {
  #             enable = true;
  #             value = "3";
  #           };
  #           # enable autoprobing of bluetooth driver
  #           # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
  #           krnbt = {
  #             enable = true;
  #             value = "on";
  #           };
  #         };
  #       };
  #     };
  #   };
  # };
}
