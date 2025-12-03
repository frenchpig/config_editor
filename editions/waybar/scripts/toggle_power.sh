#!/bin/bash

current=$(powerprofilesctl get)

if [ "$current" == "balanced" ]; then
    powerprofilesctl set performance
    notify-send "Power Profile" "Switched to Performance"
elif [ "$current" == "performance" ]; then
    powerprofilesctl set power-saver
    notify-send "Power Profile" "Switched to Power Saver"
else
    powerprofilesctl set balanced
    notify-send "Power Profile" "Switched to Balanced"
fi
