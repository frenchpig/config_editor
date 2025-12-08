#!/bin/bash
# Script para alternar entre EWW bar y Waybar

EWW_CONFIG="$HOME/.config/eww"

# Verificar si eww bar está abierta
if eww -c "$EWW_CONFIG" windows | grep -q "bar"; then
    # EWW bar está abierta, cerrarla e iniciar waybar
    eww -c "$EWW_CONFIG" close bar
    waybar &
    notify-send "Barra" "Cambiado a Waybar"
else
    # EWW bar no está abierta, cerrar waybar e iniciar eww
    pkill waybar 2>/dev/null
    sleep 0.3
    
    # Asegurarse de que el daemon de eww esté corriendo
    if ! pgrep -x "eww" > /dev/null; then
        cd "$EWW_CONFIG" && eww daemon
        sleep 0.5
    fi
    
    eww -c "$EWW_CONFIG" open bar
    notify-send "Barra" "Cambiado a EWW Bar"
fi
