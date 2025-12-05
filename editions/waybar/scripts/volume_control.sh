#!/bin/bash

current_volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

options=""
if [ "$muted" = "true" ]; then
    options="Unmute\n"
else
    options="Mute\n"
fi

options+="10%\n25%\n50%\n75%\n100%"

choice=$(echo -e "$options" | wofi -d -p "Volume: ${current_volume}%")

case "$choice" in
    "Mute")
        pamixer --toggle-mute
        ;;
    "Unmute")
        pamixer --toggle-mute
        ;;
    "10%")
        pamixer --set-volume 10
        ;;
    "25%")
        pamixer --set-volume 25
        ;;
    "50%")
        pamixer --set-volume 50
        ;;
    "75%")
        pamixer --set-volume 75
        ;;
    "100%")
        pamixer --set-volume 100
        ;;
esac

