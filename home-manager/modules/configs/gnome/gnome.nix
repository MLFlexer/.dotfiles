{ lib, config, inputs, ... }:
let
  wallpaper = builtins.toString inputs.self
    + "/home-manager/modules/configs/gnome/img/background.png";
in {
  options = { gnome.enable = lib.mkEnableOption "Enables Gnome config"; };

  config = lib.mkIf config.gnome.enable {
    # To search options:
    # gsettings list-recursively | fzf --preview 'echo {} | awk "{print \$1, \$2}" | xargs gsettings describe' --preview-window=wrap
    dconf = {
      # TODO: Make discord auto start on login: https://help.gnome.org/admin/system-admin-guide/stable/autostart-applications.html.en
      enable = true;

      # https://github.com/GNOME/gsettings-desktop-schemas
      settings = {

        "org/gnome/settings-daemon/plugins/media-keys" = {
          screensaver = [ "<Super><Ctrl><Alt>L" ];
        };

        "org/gnome/shell" = {
          favorite-apps = [
            "zen-beta.desktop"
            "org.wezfurlong.wezterm.desktop"
            "discord.desktop"
            "element-desktop.desktop"
          ] ++ lib.lists.optionals config.steam.enable [ "steam.desktop" ]
            ++ [ "org.gnome.Nautilus.desktop" ];
        };

        "org/gnome/desktop/wm/preferences" = {
          mouse-button-modifier = [ "<Super>" ];
          resize-with-right-button = true;
        };
        "org/gnome/desktop/background" = {
          picture-uri = "file://${wallpaper}";
          picture-uri-dark = "file://${wallpaper}";

          show-desktop-icons = true;
        };

        "org/gnome/desktop/interface" = {
          show-battery-percentage = true;

          accent-color = "blue";
          color-scheme = "prefer-dark";

          enable-hot-corners = config.isDesktop;
          enable-animations = true;

          clock-show-weekday = true;
          clock-show-date = true;
          clock-format = "24h";

        };

        "org/gnome/desktop/peripherals/mouse" = lib.mkIf config.isDesktop {
          accel-profile = "flat";
          speed = 0.5;
        };

        "org/gnome/desktop/peripherals/touchpad" = lib.mkIf config.hasTouchpad {
          two-finger-scroll = true;
          two-finger-scrolling-enabled = true;
          edge-scrolling-enabled = false;
          disable-while-typing = true;
          tap-button-map = "default";
          tap-and-drag-lock = false;
          accel-profile = "default";
          click-method = "fingers";
          natural-scroll = true;
          left-handed = "mouse";
          tap-to-click = true;
          tap-and-drag = true;
        };

        "org/gnome/shell/keybindings" = {
          show-screenshot-ui = [ "<Shift><Super>s" ];
        };

        "org/gnome/mutter" = {
          dynamic-workspaces = true;
          edge-tiling = true;
        };

        "org/gnome/desktop/wm/keybindings" = {
          minimize = [ ];
          toggle-maximized = [ "<Alt>F10" "<Super>z" ];
          toggle-fullscreen = [ "<Super><Shift>Z" ];

          switch-to-workspace-10 = [ "<Super><Shift>10" ];
          switch-to-workspace-9 = [ "<Super><Shift>9" ];
          switch-to-workspace-8 = [ "<Super><Shift>8" ];
          switch-to-workspace-7 = [ "<Super><Shift>7" ];
          switch-to-workspace-6 = [ "<Super><Shift>6" ];
          switch-to-workspace-5 = [ "<Super><Shift>5" ];
          switch-to-workspace-4 = [ "<Super><Shift>4" ];
          switch-to-workspace-3 = [ "<Super><Shift>3" ];
          switch-to-workspace-2 = [ "<Super><Shift>2" ];
          switch-to-workspace-1 = [ "<Super><Shift>1" ];

          move-to-workspace-10 = [ "<Super><Alt>10" ];
          move-to-workspace-9 = [ "<Super><Alt>9" ];
          move-to-workspace-8 = [ "<Super><Alt>8" ];
          move-to-workspace-7 = [ "<Super><Alt>7" ];
          move-to-workspace-6 = [ "<Super><Alt>6" ];
          move-to-workspace-5 = [ "<Super><Alt>5" ];
          move-to-workspace-4 = [ "<Super><Alt>4" ];
          move-to-workspace-3 = [ "<Super><Alt>3" ];
          move-to-workspace-2 = [ "<Super><Alt>2" ];
          move-to-workspace-1 = [ "<Super><Alt>1" ];

          switch-to-workspace-left = [ "<Control><Alt>Left" "<Super>h" ];
          switch-to-workspace-down = [ "<Control><Alt>Down" "<Super>j" ];
          switch-to-workspace-up = [ "<Control><Alt>Up" "<Super>k" ];
          switch-to-workspace-right = [ "<Control><Alt>Right" "<Super>l" ];

          move-to-workspace-left =
            [ "<Control><Shift><Alt>Left" "<Super><Shift>H" ];
          move-to-workspace-down =
            [ "<Control><Shift><Alt>Down" "<Super><Shift>J" ];
          move-to-workspace-up =
            [ "<Control><Shift><Alt>Up" "<Super><Shift>K" ];
          move-to-workspace-right =
            [ "<Control><Shift><Alt>Right" "<Super><Shift>L" ];
        };
      };
    };
  };
}

