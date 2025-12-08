#!/bin/bash
# Script para obtener información de volumen para EWW bar
# Usando iconos de Nerd Fonts con códigos Unicode

# Iconos Nerd Fonts
# Volume high: nf-md-volume_high (󰕾) - U+F057E
# Volume medium: nf-md-volume_medium (󰖀) - U+F0580
# Volume low: nf-md-volume_low (󰕿) - U+F057F
# Volume mute: nf-md-volume_mute (󰝟) - U+F075F

ICON_VOL_HIGH=$'\U000f057e'
ICON_VOL_MED=$'\U000f0580'
ICON_VOL_LOW=$'\U000f057f'
ICON_VOL_MUTE=$'\U000f075f'

volume=$(pamixer --get-volume 2>/dev/null || echo "0")
muted=$(pamixer --get-mute 2>/dev/null || echo "false")

if [ "$muted" = "true" ]; then
    echo "${ICON_VOL_MUTE} Mute"
else
    if [ "$volume" -ge 70 ]; then
        icon="$ICON_VOL_HIGH"
    elif [ "$volume" -ge 30 ]; then
        icon="$ICON_VOL_MED"
    else
        icon="$ICON_VOL_LOW"
    fi
    echo "${icon} ${volume}%"
fi
