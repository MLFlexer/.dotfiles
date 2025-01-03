{ pkgs, unstable, user, raspberry-pi-nix, ... }:
{
  time.timeZone = "Europe/Copenhagen";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";
  # Configure console keymap
  console.keyMap = "dk-latin1";

  users.users.root.initialPassword = "root";
  networking = {
    hostName = "rpi5";
    useDHCP = true;
    interfaces = { wlan0.useDHCP = true; };
    wireless = {
      enable = true;
      userControlled.enable = true;

      networks = {
      };
    };
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "${user}" ];

  users.users.${user} = {
    initialPassword = "root";
    isNormalUser = true;
    createHome = true;
    description = "${user} user.";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = (with pkgs; [
      home-manager
      tmux
      blocky
      btop
      # stable
    ]); #++ (with unstable; []);
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdXjmV661jKgb8bOQ8MqpOlNTfRSo/AneI4KqJ6dhcf malthemlarsen@gmail.com" ];
  };

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 443 53 80 4221 5000 8000 8080 25565 6969 ];
  networking.firewall.allowedUDPPortRanges = [
    { from = 2456; to = 2457; } # Valheim
    { from = 53; to = 53; } # adguard
  ];

  nix = {
    settings.auto-optimise-store = true;
    settings.experimental-features = [ "nix-command" "flakes" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ vim git bluez bluez-tools ];
  system.stateVersion = "24.05";
  raspberry-pi-nix.board = "bcm2712";
  hardware = {
    bluetooth.enable = true;
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            # enable autoprobing of bluetooth driver
            # https://github.com/raspberrypi/linux/blob/c8c99191e1419062ac8b668956d19e788865912a/arch/arm/boot/dts/overlays/README#L222-L224
            krnbt = {
              enable = true;
              value = "on";
            };
          };
        };
      };
    };
  };
}
