{ pkgs, unstable, user, ... }:
{
  # imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  # boot.loader = {
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true;
  # };

  # networking.hostName = "rpi5";
  # networking.networkmanager.enable = true;
  networking = {
    useDHCP = true;
    hostName = "rpi5";

    interfaces = { wlan0.useDHCP = true; };
      # TODO: remove
    firewall.allowedTCPPorts = [ 8000 ];

    wireless = {
      enable = true;
      userControlled.enable = true;

      # TODO: remove
      networks = {

      };
    };
  };


  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # hardware.bluetooth.enable = true;
  hardware = {
    # bluetooth.enable = true;

    raspberry-pi.config.all.base-dt-params = {
      # bluetooth
      krnbt = {
        enable = true;
        value = "on";
      };
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    createHome = true;
    description = "${user} user.";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    # packages = (with pkgs; [
    #     # stable
    # ]) ++ (with unstable; [
    #     # unstable
    # ]);
    # TODO: REMOVE THIS
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdXjmV661jKgb8bOQ8MqpOlNTfRSo/AneI4KqJ6dhcf malthemlarsen@gmail.com" ];
  };

  users.groups = {
    # raspberry needed
    gpio = { };
    i2c = { };
    spi = { };
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  programs = {
    zsh.enable = true;
  };

  # virtualisation.docker.enable = true;
  # users.extraGroups.docker.members = [ "${user}" ];

  system.stateVersion = "24.05";

  # TODO: wtf is this?
  services.journald.extraConfig = ''
    SystemMaxUse=2G
  '';

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
