{ pkgs, unstable, user, inputs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;

      windows = {
        "windows" = let
          # To determine the name of the windows boot drive, boot into edk2 first, then run
          # `map -c` to get drive aliases, and try out running `FS1:`, then `ls EFI` to check
          # which alias corresponds to which EFI partition.
          boot-drive = "FS1";
        in {
          title = "Windows";
          efiDeviceHandle = boot-drive;
          sortKey = "a_windows";
        };
      };

      edk2-uefi-shell.enable = true;
      edk2-uefi-shell.sortKey = "z_edk2";
    };
    efi.canTouchEfiVariables = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/336723
  # https://discourse.nixos.org/t/suspend-resume-cycling-on-system-resume/32322/12
  systemd = {
    services."gnome-suspend" = {
      description = "suspend gnome shell";
      before = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-suspend.service"
        "nvidia-hibernate.service"
      ];
      wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.procps}/bin/pkill -f -STOP ${pkgs.gnome-shell}/bin/gnome-shell";
      };
    };
    services."gnome-resume" = {
      description = "resume gnome shell";
      after = [
        "systemd-suspend.service"
        "systemd-hibernate.service"
        "nvidia-resume.service"
      ];
      wantedBy = [ "systemd-suspend.service" "systemd-hibernate.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          "${pkgs.procps}/bin/pkill -f -CONT ${pkgs.gnome-shell}/bin/gnome-shell";
      };
    };
  };

  # Emulate arm to cross compile raspberry pi 5
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.hostName = "desktop_nixos";
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
    ++ (with pkgs; [
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
  # sound.enable = true;
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
    packages = (with pkgs; [ home-manager discord lima ])
      ++ (with unstable; [ vscode vscodium wezterm ]);
  };

  environment.systemPackages = with pkgs; [
    cachix
    # (cutter.withPlugins (ps: with ps; [ jsdec rz-ghidra sigdb ]))
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
    gnome-weather
    gnome-system-monitor
    gnomeExtensions.vitals # system monitoring
    inputs.zen-browser.packages.${system}.default

    # for gaming
    protonup # NOTE: remember to run protonup when installing imperatively, see nixos gaming video from vimjoyer.
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
      "/home/${user}/.steam/root/compatibilitytools.d";
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

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

  system.stateVersion = "24.11";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };
}
