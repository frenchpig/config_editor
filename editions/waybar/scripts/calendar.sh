#!/bin/bash

MONITOR_INFO=$(hyprctl monitors -j | jq -r '.[0]')
MONITOR_W=$(echo "$MONITOR_INFO" | jq -r '.width')
MONITOR_H=$(echo "$MONITOR_INFO" | jq -r '.height')

WAYBAR_X=$((MONITOR_W / 2 - 150))
WAYBAR_Y=56

pkill gsimplecal || true
sleep 0.1
gsimplecal -p $WAYBAR_X,$WAYBAR_Y &

