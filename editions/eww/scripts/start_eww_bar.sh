#!/bin/bash
# Script para iniciar la barra EWW
# Este script puede usarse en lugar de waybar

EWW_CONFIG="$HOME/.config/eww"

# Matar waybar si está corriendo
pkill waybar 2>/dev/null

# Asegurarse de que el daemon de eww esté corriendo
if ! pgrep -x "eww" > /dev/null; then
    cd "$EWW_CONFIG" && eww daemon
    sleep 0.5
fi

# Abrir la barra
eww -c "$EWW_CONFIG" open bar

echo "EWW Bar iniciada"
