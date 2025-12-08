#!/bin/bash

current_brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
current_percent=$((current_brightness * 100 / max_brightness))

options="10%\n25%\n50%\n75%\n100%"

choice=$(echo -e "$options" | wofi -d -p "Brightness: ${current_percent}%")

case "$choice" in
    "10%")
        brightnessctl set 10%
        ;;
    "25%")
        brightnessctl set 25%
        ;;
    "50%")
        brightnessctl set 50%
        ;;
    "75%")
        brightnessctl set 75%
        ;;
    "100%")
        brightnessctl set 100%
        ;;
esac




