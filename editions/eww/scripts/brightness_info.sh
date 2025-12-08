#!/bin/bash
# Script para obtener información de brillo para EWW bar
# Usando iconos de Nerd Fonts con códigos Unicode

# Iconos Nerd Fonts
# Brightness high: nf-md-brightness_7 (󰃠) - U+F00E0
# Brightness medium: nf-md-brightness_6 (󰃟) - U+F00DF
# Brightness low: nf-md-brightness_5 (󰃞) - U+F00DE

ICON_BRIGHT_HIGH=$'\U000f00e0'
ICON_BRIGHT_MED=$'\U000f00df'
ICON_BRIGHT_LOW=$'\U000f00de'

brightness=$(($(brightnessctl get 2>/dev/null || echo "0") * 100 / $(brightnessctl max 2>/dev/null || echo "1")))

if [ "$brightness" -ge 70 ]; then
    icon="$ICON_BRIGHT_HIGH"
elif [ "$brightness" -ge 30 ]; then
    icon="$ICON_BRIGHT_MED"
else
    icon="$ICON_BRIGHT_LOW"
fi

echo "${icon} ${brightness}%"
