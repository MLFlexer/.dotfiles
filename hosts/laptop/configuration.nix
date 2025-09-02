{
  pkgs,
  unstable,
  user,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.niri.nixosModules.niri
    ./hardware-configuration.nix
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  # Emulate arm to cross compile raspberry pi 5
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "laptop_nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "dk";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-tour
      cheese # webcam tool
      gnome-music
      gnome-terminal
      # gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-contacts
      simple-scan # document scanner
      yelp # help client
      gnome-maps
    ]
  );

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  fonts.packages = with pkgs; [ monaspace ];
  fonts.fontconfig.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "${user} user.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
    packages =
      (with pkgs; [ discord ])
      ++ (with unstable; [
        wezterm
        element-desktop
      ]);
  };

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
  };

  environment.systemPackages = with pkgs; [
    thunderbird
    cachix
    openssl
    gnupg
    cacert
    curl
    firefox
    gcc
    kdePackages.okular # pdf reader
    # pinentry-gnome
    steam-run # to run unpatched binaies
    unzip
    vim
    vlc
    wget
    zip
    gnome-weather
    gnome-system-monitor
    gnomeExtensions.vitals # system monitoring
    inputs.zen-browser.packages.${system}.default
  ];

  programs = {
    zsh.enable = true;
    nix-ld.enable = true; # run unpatched binaries

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableSSHSupport = true;
    };
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "${user}" ];

  system.stateVersion = "25.05";

  nix = {
    package = pkgs.nixVersions.stable;
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
}
