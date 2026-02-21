{
  pkgs,
  unstable,
  user,
  raspberry-pi-nix,
  ...
}:
{
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_DK.UTF-8";
  console.keyMap = "dk-latin1";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4BE3-15FF";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8b57d8e1-2422-44bd-bc49-38af5feb820b";
    fsType = "ext4";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/820d1ec4-7d6e-46cf-bcdd-0f6a138a19b4"; }
  ];

  fileSystems = {
    "/mnt/usbdrive2" = {
      device = "/dev/disk/by-uuid/6def3262-e479-4b32-b6f1-14a19989c546";
      fsType = "ext4";
      options = [
        "defaults"
        "nofail"
      ];
    };
  };

  users.groups.usbdrive2 = {
    name = "usbdrive2";
  };

  systemd.tmpfiles.rules = [ "d /mnt/usbdrive2 0755 usbdrive2 usbdrive2 -" ];

  users.users.root.initialPassword = "root";
  networking = {
    hostName = "rpi5";
    useDHCP = true;
    interfaces = {
      wlan0.useDHCP = true;
    };
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
    packages =
      (with pkgs; [
        cachix
        tmux
        btop
        # stable
      ])
      ++ (with unstable; [ wezterm ]);

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdXjmV661jKgb8bOQ8MqpOlNTfRSo/AneI4KqJ6dhcf malthemlarsen@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARHveCo8QOYQzd4rUYdPR37iXMe6wW+XgUacnmJfkwN malthemlarsen@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAGGWh0SZQ8GPQEjlUDKgqoRa1tALsoaa20//oTGxqWR malthemlarsen@gmail.com"
    ];
  };

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    # settings.PasswordAuthentication = false;
    # challengeResponseAuthentication = false;
    allowSFTP = true;
    # ports = [ 2222 ];
  };

  networking.firewall.allowedTCPPorts = [
    # 22
    12345
    25565
    25566
    # 3000
    # 4221
    #
    8173
    443
    5000
    # 53
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

  networking.firewall.extraInputRules = ''
    iptables -A INPUT -p udp --dport 22 -s 192.168.1.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
  '';

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "mlflexer"
      ];
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
    helix
    git
    bluez
    bluez-tools
    unzip
    raspberrypi-eeprom
    rpi-imager
    yazi
  ];

  hardware.bluetooth.enable = true;

  system.stateVersion = "25.11";
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
