{
  config,
  pkgs,
  ...
}:
  let

base00 = "242424"; # ----
      base01 = "3c3836"; # ---
      base02 = "504945"; # --
      base03 = "665c54"; # -
      base04 = "bdae93"; # +
      base05 = "d5c4a1"; # ++
      base06 = "ebdbb2"; # +++
      base07 = "fbf1c7"; # ++++
      base08 = "fb4934"; # red
      base09 = "fe8019"; # orange
      base0A = "fabd2f"; # yellow
      base0B = "b8bb26"; # green
      base0C = "8ec07c"; # aqua/cyan
      base0D = "7daea3"; # blue
      base0E = "e089a1"; # purple
      base0F = "f28534"; # brown
          in{
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
          "image"
          "niri/workspaces"
          "idle_inhibitor"
          "niri/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "group/network-modules"
          "group/wireplumber-modules"
          #          "group/backlight-modules"
          "group/battery-modules"
          "custom/notifications"
          "group/powermenu"
        ];

        "image" = {
          path = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          size = 24;
          tooltip = false;
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
          tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-disconnected = "Disconnected";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };
        "network#address" = {
          format-disconnected = "Disconnected";
          format-ethernet = "{ipaddr}/{cidr}";
          format-wifi = "{essid}";
          tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
          tooltip-format-ethernet = "Ethernet: {ifname}\n󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}";
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

        "group/backlight-modules" = {
          modules = [
            "backlight#icon"
            "backlight#percent"
          ];
          orientation = "inherit";
        };
        "backlight#icon" = {
          format = "{icon}";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+ &> /dev/null";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 1%- &> /dev/null";
          tooltip-format = "Backlight: {percent}%";
        };
        "backlight#percent" = {
          format = "{percent}%";
          tooltip-format = "Backlight: {percent}%";
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
              days = "<span color='#${base0A}'><b>{}</b></span>";
              months = "<span color='#${base0D}'><b>{}</b></span>";
              today = "<span color='#${base0D}'><b><u>{}</u></b></span>";
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
        font-family: "Adwaita Sans";
        font-size: 9pt;
        font-weight: 600;
      }

      /* Menu */
      menu {
        background: #${base00};
        border-radius: 12px;
      }

      menu separator {
        background: #${base0E};
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
        background: #${base08};
        color: #${base00};
        border-radius: 8px;
        font-size: 11pt;
        padding: 0.25rem;
        padding-right: 0.5rem;
        min-width: 1.5rem;
      }

      #wireplumber.icon {
        background: #${base0F};
        color: #${base00};
        border-radius: 8px;
        font-size: 13pt;
        padding: 0.25rem;
        min-width: 1.5rem;
      }

      #backlight.icon,

      #battery.icon {
        background: #${base0A};
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
        background: #${base0C};
        color: #${base00};
        border-radius: 8px;
        font-size: 13pt;
        padding: 0.25rem;
        min-width: 1.5rem;
        transition: 300ms linear;
      }

      #custom-notifications {
        background: #${base0D};
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
        background: #${base08};
      }

      #workspaces button.active {
        background: #${base0B};
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
    '';
  };
}
