{ pkgs, unstable, user, ... }: {
  imports = [ ./hardware-configuration.nix ]; # ./cachix.nix];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  # Emulate arm to cross compile raspberry pi 5
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

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

    # Enable GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "dk";
      # xkbVariant = "";
    };
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  environment.gnome.excludePackages = (with pkgs; [ gnome-tour ])
    ++ (with pkgs.gnome; [
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
    ]);

  # Configure console keymap
  console.keyMap = "dk-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.bluetooth.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    packages = (with pkgs; [ discord lima ])
      ++ (with unstable; [ vscode vscodium wezterm ]);
  };

  environment.systemPackages = with pkgs; [
    cachix
    (cutter.withPlugins (ps: with ps; [ jsdec rz-ghidra sigdb ]))
    openssl
    gnupg
    # obs-studio 
    # anki-bin
    cacert
    curl
    firefox
    gcc
    okular # pdf reader
    # pinentry-gnome
    steam-run # to run unpatched binaies
    unzip
    vim
    vlc
    wget
    zip
    gnome.gnome-weather
    gnome.gnome-system-monitor
    gnomeExtensions.openweather
    gnomeExtensions.vitals # system monitoring
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

  system.stateVersion = "24.05";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
