{ pkgs, unstable, user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

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
    layout = "dk";
    xkbVariant = "";

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
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
    packages = with pkgs; [
      discord
      unstable.vscode
      unstable.vscodium
      unstable.wezterm
    ];
  };

  environment.variables = {
    # fix for this curl issue with https requests: https://github.com/NixOS/nixpkgs/issues/148686
    CURL_CA_BUNDLE = "/etc/pki/tls/certs/ca-bundle.crt"; # this is the value of $SSL_CERT_FILE ; may be brittle
  };

  environment.systemPackages = with pkgs; [
    # gnupg
    # obs-studio 
    # anki-bin
    cacert
    curl
    firefox
    gcc
    okular # pdf reader
    pinentry-gnome
    steam-run # to run unpatched binaies
    unzip
    vim
    vlc
    wget
    zip
    gnome.gnome-weather
    gnome.gnome-system-monitor
    gnomeExtensions.gsconnect
    gnomeExtensions.openweather
    gnomeExtensions.vitals # system monitoring
  ];

  networking.firewall.allowedTCPPortRanges = [{ from = 1714; to = 1764; }]; # Open ports for GSConnect
  networking.firewall.allowedUDPPortRanges = [{ from = 1714; to = 1764; }]; # Open ports for GSConnect

  programs = {
    zsh.enable = true;
    gpaste.enable = true; # clipboard manager
    nix-ld.enable = true; # run unpatched binaries

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "${user}" ];

  system.stateVersion = "23.11";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
