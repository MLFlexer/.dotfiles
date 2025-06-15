{ config, lib, system, pkgs, inputs, ... }: {
  options = { niri.enable = lib.mkEnableOption "Enables Niri compositor"; };

  config = lib.mkIf config.niri.enable {

    home.packages = [ pkgs.wl-clipboard ];

    programs.niri.settings = {

      spawn-at-startup = [
        # (makeCommand "uwsm finalize")
        # (makeCommand "hyprlock")
        # (makeCommand "swww-daemon")
        {
          command = [ "waybar" ];
        }
        # (makeCommand "keepassxc")
        # (makeCommand "xwayland-satellite")
        # (makeCommand "telegram-desktop")
        # (makeCommand "wl-paste --type image --watch cliphist store")
        # (makeCommand "wl-paste --type text --watch cliphist store")
      ];
      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "wezterm";
        "Mod+b".action = spawn "zen";
        "Mod+Shift+E".action = quit;

        "Mod+U".action =
          spawn "env XDG_CURRENT_DESKTOP=gnome gnome-control-center";

        "Mod+Q".action = close-window;
        "Mod+S".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        # "Mod+Shift+F".action = fullscreen-window;
        "Mod+Shift+F".action = expand-column-to-available-width;
        "Mod+Space".action = toggle-window-floating;
        "Mod+W".action = toggle-column-tabbed-display;

        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;
        "Mod+C".action = center-window;
        "Mod+Tab".action = switch-focus-between-floating-and-tiling;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Plus".action = set-window-height "+10%";

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+J".action = focus-window-or-workspace-down;
        "Mod+K".action = focus-window-or-workspace-up;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Down".action = focus-workspace-down;
        "Mod+Up".action = focus-workspace-up;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-column-to-workspace-up;
        "Mod+Shift+J".action = move-column-to-workspace-down;
      };

      input = { keyboard = { xkb = { layout = "dk"; }; }; };

      layout = {
        focus-ring.enable = false;
        border = {
          enable = true;
          width = 2;
          # active.color = "#${config.lib.stylix.colors.base05}";
          # inactive.color = "#${config.lib.stylix.colors.base03}";
        };

        gaps = 0;
        struts = {
          left = 2;
          right = 2;
          top = 0;
          bottom = 0;
        };
      };

    };

    # WAYBAR
    programs.waybar = {
      enable = true;
      systemd.target = "niri-session";

      #       settings = {

      #   mainBar = {
      #     layer = "top";
      #     position = "top";
      #     height = 20;
      #     output = [
      #       "eDP-1"
      #       # "HDMI-A-1"
      #     ];
      #     modules-left = [ "niri/workspaces" "wlr/taskbar" "niri/windows" ];
      #     modules-center = [ "clock" ];
      #     modules-right = [ "load" "memory" "network" "pulseaudio/slider" "mpd" "custom/mymodule#with-css-id" "battery" ];

      #     # TODO: tray
      #     # "sway/workspaces" = {
      #     #   disable-scroll = true;
      #     #   all-outputs = true;
      #     # };
      #     "custom/hello-from-waybar" = {
      #       format = "hello {}";
      #       max-length = 40;
      #       interval = "once";
      #       exec = pkgs.writeShellScript "hello-from-waybar" ''
      #         echo "from within waybar"
      #       '';
      #     };

      #     "niri/workspaces" = {
      # 	format = "{icon}";
      # 	format-icons = {
      # 		browser = "";
      # 		discord = "";
      # 		chat = "<b></b>";

      # 		active = "";
      # 		default = "";
      # 	};
      # };

      # "niri/window"= {
      # 	format= "{}";
      # 	rewrite= {
      # 		"(.*) - Mozilla Firefox"= "🌎 $1";
      # 		"(.*) - zsh"= "> [$1]";
      # 	};
      # };
      #     # TODO: add bluetooth
      #     # TODO: add privacy module

      #     clock= { # TODO: add calendar
      #     interval= 60;
      #     format= "{:%H:%M}";
      #     max-length= 25;
      # };

      # network = {
      #     interface = "wlp2s0";
      #     format = "{ifname}";
      #     format-wifi = "{essid} ({signalStrength}%) ";
      #     format-ethernet = "{ipaddr}/{cidr} 󰊗";
      #     format-disconnected = "";
      #     tooltip-format = "{ifname} via {gwaddr} 󰊗";
      #     tooltip-format-wifi = "{essid} ({signalStrength}%) ";
      #     tooltip-format-ethernet = "{ifname} ";
      #     tooltip-format-disconnected = "Disconnected";
      #     max-length = 50;
      # };

      # load= {
      #     interval= 10;
      #     format= "load= {load1}";
      #     max-length= 10;
      # }    ;

      # memory= {
      #     interval= 30;
      #     format= "{}% ";
      #     max-length= 10;
      # };
      # "pulseaudio/slider" = {
      #     min = 0;
      #     max = 100;
      #     orientation = "horizontal";
      # };

      #     battery= {
      #     # bat= "BAT2";
      #     interval= 60;
      #     states= {
      #         warning= 30;
      #         critical= 15;
      #     };
      #     format= "{capacity}% {icon}";
      #     format-icons= ["" "" "" "" ""];
      #     max-length= 25;
      # };
      #   };        
      #       };

    };
  };
}
