#!/bin/bash
EWW_CONFIG="$HOME/.config/eww"
WIDGET_NAME="power_profile"

# El flag --toggle abre si está cerrado, y cierra si está abierto
eww -c $EWW_CONFIG open $WIDGET_NAME --toggle
