#!/usr/bin/env bash
 
# To get the windows booting you must have systemdboot and then find the id from `bootctl list`.
# Then this is used with the cmd: `systemctl reboot --boot-loader-entry=<id>`, where <id> is the boot entry id.
show_system_menu() {
  local choice=$(menu "System" "  Lock\n󰤄  Suspend\n󰍃  Logout\n󰜉  Restart\n󰖳  Windows\n󰐥  Shutdown")
  case $choice in
  *Lock*) swaylock -F -i "/home/mlflexer/repos/.dotfiles/home-manager/modules/configs/gnome/img/background.png" -l --font "MonaspiceNe Nerd Font" ;;
  *Suspend*) systemctl suspend ;;
  *Logout*) niri msg action quit;;
  *Restart*) systemctl reboot ;;
  *Windows*) systemctl reboot --boot-loader-entry=windows_windows.conf ;;
  *Shutdown*) systemctl poweroff ;;
  *) echo "DEFAULT OPTION" ;;
  esac
}


menu() {
  local prompt="$1"
  local options="$2"
  local extra="$3"
  local preselect="$4"

  read -r -a args <<<"$extra"

  if [[ -n "$preselect" ]]; then
    local index
    index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
    if [[ -n "$index" ]]; then
      args+=("-a" "$index")
    fi
  fi

  echo -e "$options" | walker --dmenu -p "$prompt…" "${args[@]}"
}

show_system_menu
