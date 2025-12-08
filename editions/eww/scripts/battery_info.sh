#!/bin/bash
# Script para obtener información de batería para EWW bar
# Usando iconos de Nerd Fonts con códigos Unicode

# Iconos Nerd Fonts para batería
# Battery levels: nf-md-battery family
ICON_BAT_100=$'\U000f0079'    # 󰁹
ICON_BAT_90=$'\U000f0082'     # 󰂂
ICON_BAT_80=$'\U000f0081'     # 󰂁
ICON_BAT_70=$'\U000f0080'     # 󰂀
ICON_BAT_60=$'\U000f007f'     # 󰁿
ICON_BAT_50=$'\U000f007e'     # 󰁾
ICON_BAT_40=$'\U000f007d'     # 󰁽
ICON_BAT_30=$'\U000f007c'     # 󰁼
ICON_BAT_20=$'\U000f007b'     # 󰁻
ICON_BAT_10=$'\U000f007a'     # 󰁺
ICON_BAT_CHARGING=$'\U000f0084' # 󰂄
ICON_BAT_PLUGGED=$'\U000f06a5'  # 󰚥

battery_path="/sys/class/power_supply/BAT0"

if [ -d "$battery_path" ]; then
    capacity=$(cat "$battery_path/capacity" 2>/dev/null || echo "0")
    status=$(cat "$battery_path/status" 2>/dev/null || echo "Unknown")
    
    if [ "$status" = "Charging" ]; then
        icon="$ICON_BAT_CHARGING"
    elif [ "$status" = "Full" ]; then
        icon="$ICON_BAT_PLUGGED"
    elif [ "$capacity" -ge 90 ]; then
        icon="$ICON_BAT_100"
    elif [ "$capacity" -ge 80 ]; then
        icon="$ICON_BAT_90"
    elif [ "$capacity" -ge 70 ]; then
        icon="$ICON_BAT_80"
    elif [ "$capacity" -ge 60 ]; then
        icon="$ICON_BAT_70"
    elif [ "$capacity" -ge 50 ]; then
        icon="$ICON_BAT_60"
    elif [ "$capacity" -ge 40 ]; then
        icon="$ICON_BAT_50"
    elif [ "$capacity" -ge 30 ]; then
        icon="$ICON_BAT_40"
    elif [ "$capacity" -ge 20 ]; then
        icon="$ICON_BAT_30"
    elif [ "$capacity" -ge 10 ]; then
        icon="$ICON_BAT_20"
    else
        icon="$ICON_BAT_10"
    fi
    
    echo "${icon} ${capacity}%"
else
    echo "${ICON_BAT_PLUGGED} AC"
fi
