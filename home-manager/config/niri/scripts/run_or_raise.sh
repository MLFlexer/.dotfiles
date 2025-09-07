#!/usr/bin/env bash

APP=$1

# handle special cases
case "$APP" in
    wezterm)
        APP_ID="org.wezfurlong.wezterm"
        SPAWN_CMD="wezterm"
        ;;
    *)
        APP_ID="$APP"
        SPAWN_CMD="$APP"
        ;;
esac

# there may be instances of the app
declare -a INSTANCES

# get id of every possible instance
INSTANCES=($(niri msg -j windows | jq ".[] | select(.app_id==\"$APP_ID\")" | jq '.["id"]'))

# if there is no instance: launch
if [ ${#INSTANCES[@]} -eq 0 ]; then
    niri msg action spawn -- "$SPAWN_CMD"
else
    # if there is only one instance, focus it
    if [ ${#INSTANCES[@]} -eq 1 ]; then
        niri msg action focus-window --id "$INSTANCES"
    else
        # if there are more instances
        ISORTED=( $( printf "%s\n" "${INSTANCES[@]}" | sort -n ) )

        # get id of currently focused window
        FOCUSED=$(niri msg -j focused-window | jq '.id')

        # if no instance is in focus, focus the first one
        if [[ ! " ${ISORTED[@]} " =~ ${FOCUSED} ]]; then
            niri msg action focus-window --id "${ISORTED[0]}"
        else
            # if an instance is already in focus, focus next one
            count=-1
            for i in "${ISORTED[@]}"; do
                ((count=count+1))
                if [ $i -eq ${FOCUSED} ]; then
                    ((new_index=$count+1))
                fi
            done

            # if focus is already on the last instance, wrap to first
            if [[ "$new_index" -eq "${#INSTANCES[@]}" ]]; then
                ((new_index=0))
            fi

            niri msg action focus-window --id "${ISORTED[new_index]}"
        fi
    fi
fi
