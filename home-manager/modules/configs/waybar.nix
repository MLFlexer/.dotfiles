{ config, pkgs, ... }:
let

  base00 = "242424"; # ----
  base01 = "3c3836"; # ---
  base02 = "504945"; # --
  base03 = "665c54"; # -
  base04 = "bdae93"; # +
  base05 = "d5c4a1"; # ++
  base06 = "ebdbb2"; # +++
  base07 = "fbf1c7"; # ++++
  red = "fb4934"; # red
  orange = "fe8019"; # orange
  yellow = "fabd2f"; # yellow
  green = "b8bb26"; # green
  cyan = "8ec07c"; # aqua/cyan
  blue = "7daea3"; # blue
  purple = "e089a1"; # purple
  brown = "f28534"; # brown
in
{
  # TODO: set enable option
  programs.waybar = {
    settings = [
      {
        layer = "top";
        position = "top";
        exclusive = true;
        fixed-center = true;
        gtk-layer-shell = true;
        spacing = 0;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [
          # Workspaces
          # taskbar
          # current window??? (not needed because of taskbar?)
          "niri/workspaces"
          "niri/window"
          "wlr/taskbar"
        ];
        modules-center = [
          # Clock with caldendar on click
          # notifications
          # weather?
          # next event nofitication?
          "clock"
          "custom/notifications"
        ];
        modules-right = [
          # system load menu
          # privacy
          # bluetooth
          # audio
          # network
          # power + profile selector
          # shutdown menu + idle inhibitor

          "group/usage"
          "tray"
          "bluetooth"
          "group/audio"
          "group/power"
          "group/network-modules"
          # "group/wireplumber-modules"
          #          "group/backlight-modules"
          # "power-profiles-daemon"
          # "group/battery-modules"
          "group/powermenu"
        ];

        "group/usage" = {
          modules = [
            "group/cpu"
            "group/memory"
            "group/disk"
          ];
          orientation = "inherit";

        };

        # POWER:
        "group/power" = {
          drawer = {
            children-class = "power-child";
            transition-duration = 300;
            transition-left-to-right = true;
            click-to-reveal = true;
          };

          modules = [
            "group/battery-modules"
            "power-profiles-daemon"
          ];
          orientation = "inherit";

        };

        # CPU_USSAGE:
        "group/cpu" = {
          drawer = {
            children-class = "cpu-child";
            transition-duration = 300;
            transition-left-to-right = true;
            click-to-reveal = true;
          };
          modules = [ "cpu#load" ];
          orientation = "inherit";
        };

        "cpu#load" = {
          interval = 10;
          format = "{}% ";
          max-length = 10;
        };

        # MEM_USSAGE:
        "group/memory" = {
          drawer = {
            children-class = "memory-child";
            transition-duration = 300;
            transition-left-to-right = true;
            click-to-reveal = true;
          };

          modules = [
            "memory#used"
            "memory#total"
            "memory#swap"
          ];
          orientation = "inherit";

        };
        "memory#used" = {
          format = "{used:0.1f} GB ";
          interval = 30;
          tooltip = false;
          states = {
            # TODO: color based on state
            low = 0;
            half = 50;
            high = 75;
            very_high = 90;
          };
        };
        "memory#total" = {
          format = " Used: {used:0.1f} / {total:0.1f} GB";
          interval = 30;
          tooltip = false;
        };
        "memory#swap" = {
          format = "Swap: {swapUsed:0.1f} / {swapTotal:0.1f} GB";
          interval = 30;
          tooltip = false;
        };

        # DISK_USSAGE:
        "group/disk" = {
          drawer = {
            children-class = "disk-child";
            transition-duration = 300;
            transition-left-to-right = true;
            click-to-reveal = true;
          };
          modules = [ "disk#usage" ];
          orientation = "inherit";
        };

        "disk#usage" = {
          "interval" = 30;
          "format" = "{free} ";
        };

        # AUDIO:
        "group/audio" = {
          drawer = {
            children-class = "audio-child";
            transition-duration = 300;
            transition-left-to-right = true;
          };
          modules = [
            "pulseaudio#icon"
            "pulseaudio/slider"
          ];
          orientation = "inherit";
        };

        "pulseaudio#icon" = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          format-muted = "󰖁";
          format-icons = {
            headphone = "";
            hands-free = "󱡒";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = [
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle &> /dev/null";
          tooltip-format = "Volume: {volume}%";
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 100;
          orientation = "horizontal";
        };

        # TODO:
        # ussage
        # Memory in group to show swap
        # CPU in group to show ??? + temp on hover + cpu load???
        # disk ussage total
        #
        # Network in group to show down/up
        # Battery group with slider for power profile?
        # Audio with slider on hover
        # bluetooth???
        # Power in group to show logout etc. + idle inhibitor
        # Clock + calendar + weather???
        # Privacy: webcam + screen capture + audio in
        # notifications list ability to clear and no notify
        #
        # EXTRA: systemd units failed - hide on okay?
        # Next calendar event
        # Reminders
        # screen brightness/night light
        # Quicknotes/todo list
        # gamemode?

        "power-profiles-daemon" = {
          "format" = "{icon}   {profile}";
          "tooltip-format" = ''
            Power profile: {profile}
            Driver: {driver}'';
          "tooltip" = true;
          "format-icons" = {
            "default" = "";
            "performance" = "";
            "balanced" = "";
            "power-saver" = "";
          };
        };

        "bluetooth" = {
          "format" = " {status}";
          "format-connected" = " {device_alias}";
          "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
          # "format-device-preference"= [ "device1" "device2" ]; # preference list deciding the displayed device
          "tooltip-format" = ''
            {controller_alias}	{controller_address}

            {num_connections} connected'';
          "tooltip-format-connected" = ''
            {controller_alias}	{controller_address}

            {num_connections} connected

            {device_enumerate}'';
          "tooltip-format-enumerate-connected" = "{device_alias}	{device_address}";
          "tooltip-format-enumerate-connected-battery" =
            "{device_alias}	{device_address}	{device_battery_percentage}%";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          ignore-list = [ "Alacritty" ];
          app_ids-mapping = {
            firefoxdeveloperedition = "firefox-developer-edition";
          };
          rewrite = {
            "Firefox Web Browser" = "Firefox";
            "Foot Server" = "Terminal";
          };
        };

        "niri/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          all-outputs = true;
          format-icons = {
            "default" = "";
            "urgent" = "";
            "focused" = "";
          };
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        "niri/window" = {
          format = "󰣆  {title}";
          max-length = 40;
          separate-outputs = true;
          rewrite = {
            "^.*( — Zen Browser|Zen Browser)$" = "󰈹 Zen";
            "^.*( — Firefox|Firefox)$" = "󰈹 Firefox";
            "^.*( — Chromium|Chromium)$" = "󰈹 Chromium";
            "^.*v( .*|$)" = " Neovim";
            "^.*~$" = "󰄛 Kitty";
            "^.*(- Spotify|Spotify)$" = "󰏤 Spotify";
            "^.*(- Code|Code)$" = "󰈹 VSCode";
            "(.*) " = " Empty";
          };
        };

        "group/network-modules" = {
          modules = [
            "network#icon"
            "network#address"
          ];
          orientation = "inherit";
        };
        "network#icon" = {
          format-disconnected = "󰤮";
          format-ethernet = "󰈀";
          format-wifi = "󰤨";
          tooltip-format-wifi = ''
            WiFi: {essid} ({signalStrength}%)
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}'';
          tooltip-format-ethernet = ''
            Ethernet: {ifname}
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}'';
          tooltip-format-disconnected = "Disconnected";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };
        "network#address" = {
          format-disconnected = "Disconnected";
          format-ethernet = "{ipaddr}/{cidr}";
          format-wifi = "{essid}";
          tooltip-format-wifi = ''
            WiFi: {essid} ({signalStrength}%)
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}'';
          tooltip-format-ethernet = ''
            Ethernet: {ifname}
            󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}'';
          tooltip-format-disconnected = "Disconnected";
        };

        "group/wireplumber-modules" = {
          modules = [
            "wireplumber#icon"
            "wireplumber#volume"
          ];
          orientation = "inherit";
        };

        "wireplumber#icon" = {
          format = "{icon}";
          format-muted = "󰖁";
          format-icons = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle &> /dev/null";
          on-scroll-up = "${pkgs.wireplumber}/bin/wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%+ &> /dev/null";
          on-scroll-down = "${pkgs.wireplumber}/bin/wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 1%- &> /dev/null";
          tooltip-format = "Volume: {volume}%";
        };
        "wireplumber#volume" = {
          format = "{volume}%";
          tooltip-format = "Volume: {volume}%";
        };

        "group/battery-modules" = {
          modules = [
            "battery#icon"
            "battery#capacity"
          ];
          orientation = "inherit";
        };
        "battery#icon" = {
          format = "{icon}";
          format-charging = "󱐋";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = "󰚥";
          states = {
            warning = 30;
            critical = 15;
          };
          tooltip-format = "{timeTo}, {capacity}%";
        };
        "battery#capacity" = {
          format = "{capacity}%";
          tooltip-format = "{timeTo}, {capacity}%";
        };

        tray = {
          icon-size = 10;
          spacing = 8;
          show-passive-items = false;
        };

        clock = {
          actions = {
            on-scroll-down = "shift_down";
            on-scroll-up = "shift_up";
          };
          calendar = {
            format = {
              days = "<span color='#${yellow}'><b>{}</b></span>";
              months = "<span color='#${blue}'><b>{}</b></span>";
              today = "<span color='#${blue}'><b><u>{}</u></b></span>";
              weekdays = "<span color='#${base05}'><b>{}</b></span>";
            };
            mode = "month";
            on-scroll = 1;
          };
          format = "{:%I:%M %p}";
          tooltip-format = "{calendar}";
        };

        "group/powermenu" = {
          drawer = {
            children-class = "powermenu-child";
            transition-duration = 300;
            transition-left-to-right = false;
          };
          modules = [
            "custom/power"
            "custom/lock"
            "custom/suspend"
            "custom/exit"
            "custom/reboot"
            "idle_inhibitor"
          ];
          orientation = "inherit";
        };
        "custom/power" = {
          format = "󰐥";
          on-click = "${pkgs.systemd}/bin/systemctl poweroff";
          tooltip = false;
        };
        "custom/lock" = {
          format = "󰌾";
          on-click = "${pkgs.systemd}/bin/loginctl lock-session";
          tooltip = false;
        };
        "custom/suspend" = {
          format = "󰤄";
          on-click = "${pkgs.systemd}/bin/systemctl suspend";
          tooltip = false;
        };
        "custom/exit" = {
          format = "󰍃";
          on-click = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
          tooltip = false;
        };
        "custom/reboot" = {
          format = "󰜉";
          on-click = "${pkgs.systemd}/bin/systemctl reboot";
          tooltip = false;
        };
        # TODO: fix notifications to not use sway
        "custom/notifications" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "󱅫 ";
            none = "󰂚 ";
            dnd-notification = "󰂛 ";
            dnd-none = "󰂛 ";
            inhibited-notification = "󰂚 ";
            inhibited-none = "󰂚 ";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰂛 ";
          };
          return-type = "json";
          exec-if = "${pkgs.swaynotificationcenter}/bin/swaync-client";
          exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          on-click-right = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          escape = true;
        };
      }
    ];

    style = ''
                  /* Global */
                  * {
                    all: unset;
                    font-family: "Monaspace Neon";
                    font-size: 9pt;
                    font-weight: 600;
                  }

                  /* Menu */
                  menu {
                    background: #${base00};
                    border-radius: 12px;
                  }

                  menu separator {
                    background: #${purple};
                  }

                  menu menuitem {
                    background: transparent;
                    padding: 0.5rem;
                    transition: 300ms linear;
                  }

                  menu menuitem:hover {
                    background: #${base03};
                  }

                  menu menuitem:first-child {
                    border-radius: 12px 12px 0 0;
                  }

                  menu menuitem:last-child {
                    border-radius: 0 0 12px 12px;
                  }

                  menu menuitem:only-child {
                    border-radius: 12px;
                  }

                  /* Tooltip */
                  tooltip {
                    background: #${base00};
                    border-radius: 12px;
                    padding: 0.5rem;
                  }

                  tooltip label {
                    margin: 0.5rem;
                  }

                  /* Waybar */
                  window#waybar {
                    background: transparent;
                  }

                  .modules-left {
                    padding-left: 0.25rem;
                  }

                  .modules-right {
                    padding-right: 0.25rem;
                  }

                  /* Modules */

                  #window {
                    background: #d5c4a1;
                    margin: 0.5rem 0.25rem;
                    border-radius: 8px;
                  }
                  #workspaces,
                  #workspaces button,
                  #idle_inhibitor,
                  #wireplumber-modules,
                  #backlight-modules,
                  #battery-modules,
                  #network-modules,
                  #tray,
                  #clock,
                  #custom-exit,
                  #custom-lock,
                  #custom-suspend,
                  #custom-reboot,
                  #custom-power {
                    background: #${base05};
                    border-radius: 8px;
                    margin: 0.5rem 0.25rem;
                    transition: 300ms linear;
                  }

                  #image,
                  #window,
                  #network.address,
                  #wireplumber.volume,
                  #backlight.percent,
                  #battery.capacity,
                  #tray,
                  #clock {
                    padding: 0.25rem 0.75rem;
                    color: #${base00};
                  }

                  #idle_inhibitor,

                  #network.icon {
                    background: #${red};
                    color: #${base00};
                    border-radius: 8px;
                    font-size: 11pt;
                    padding: 0.25rem;
                    padding-right: 0.5rem;
                    min-width: 1.5rem;
                  }

                  #wireplumber.icon {
                    background: #${brown};
                    color: #${base00};
                    border-radius: 8px;
                    font-size: 13pt;
                    padding: 0.25rem;
                    min-width: 1.5rem;
                  }

                  #backlight.icon,

                  #battery.icon {
                    background: #${yellow};
                    color: #${base00};
                    border-radius: 8px;
                    font-size: 9pt;
                    padding: 0.25rem;
                    min-width: 1.5rem;
                  }
                  #custom-exit,
                  #custom-lock,
                  #custom-suspend,
                  #custom-reboot,
                  #custom-power {
                    background: #${cyan};
                    color: #${base00};
                    border-radius: 8px;
                    font-size: 13pt;
                    padding: 0.25rem;
                    min-width: 1.5rem;
                    transition: 300ms linear;
                  }

                  #custom-notifications {
                    background: #${blue};
                    color: #${base00};
                    border-radius: 8px;
                    font-size: 14pt;
                    padding-left: 0.76rem;
                    min-width: 1.5rem;
                    margin: 0.5rem 0.25rem;
                  }

                  /* Workspaces */
                  #workspaces button {
                    margin: 0;
                    padding: 0.25rem;
                    min-width: 1.5rem;
                  }

                  #workspaces button label {
                    color: #${base00};
                  }

                  #workspaces button.empty label {
                    color: #${base00};
                  }

                  #workspaces button.urgent label,
                  #workspaces button.active label {
                    color: #${base00};
                  }

                  #workspaces button.urgent {
                    background: #${red};
                  }

                  #workspaces button.active {
                    background: #${green};
                  }

                  /* Idle Inhibitor */
                  #idle_inhibitor {
                    background: #${base05};
                    color: #${base00};
                  }

                  #idle_inhibitor.deactivated {
                    color: #${base00};
                    background: #${base03};
                  }

                  /* Systray */

                  #tray {
                    background: #${base00};
                  }

                  #tray > .passive {
                    -gtk-icon-effect: dim;
                  }

                  #tray > .needs-attention {
                    -gtk-icon-effect: highlight;
                    background: #${base03};
                  }

                  /* Hover effects */
                  #workspaces button:hover {
                    background: #665c54; /*base3*/
                  }
                  #idle_inhibitor:hover,
                  #idle_inhibitor.deactivated:hover,
                  #clock:hover {
                    background: #${base07};
                  }

                  #workspaces button.urgent:hover {
                    background: #${base04};
                  }

                  #workspaces button.active:hover {
                    background: #665c54; /*base3*/
                  }

                  #network.icon:hover,
                  #wireplumber.icon:hover,
                  #custom-exit:hover,
                  #custom-lock:hover,
                  #custom-suspend:hover,
                  #custom-reboot:hover,
                  #custom-power:hover {
                    background: #${base07};
                  }

                  #workspaces button.urgent:hover label,
                  #workspaces button.active:hover label {
                    color: #${base05};
                  }

                  #network.icon:hover label,
                  #wireplumber.icon:hover label,
                  #custom-exit:hover label,
                  #custom-lock:hover label,
                  #custom-suspend:hover label,
                  #custom-reboot:hover label,
                  #custom-power:hover label {
                    color: #${base00};
                  }

                  #workspaces button:hover label {
                    color: #${base05};
                  }

                  #workspaces button.empty:hover label {
                    color: #${base05};
                  }

                  #idle_inhibitor:hover {
                    color: #${base03};
                  }

                  #idle_inhibitor.deactivated:hover {
                    color: #${base02};
                  }

      #pulseaudio-slider slider {
          min-height: 10px;
          min-width: 10px;
          border-radius: 50%;
          background-color: #ffffff;
          border: 2px solid #4caf50; /* subtle green border */
          box-shadow: 0 0 4px rgba(0, 0, 0, 0.3);
          transition: background-color 0.2s, box-shadow 0.2s;
      }

      #pulseaudio-slider slider:hover {
          background-color: #4caf50;
          box-shadow: 0 0 6px rgba(76, 175, 80, 0.5);
      }

      #pulseaudio-slider trough {
          min-height: 10px;
          min-width: 100px;
          border-radius: 5px;
          background-color: #1e1e2e; /* dark muted background */
          box-shadow: inset 0 0 3px rgba(0, 0, 0, 0.6);
      }

      #pulseaudio-slider highlight {
          border-radius: 5px;
          background-color: #4caf50; /* modern green */
      }
    '';
  };
}
