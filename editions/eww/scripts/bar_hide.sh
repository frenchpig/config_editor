#!/bin/bash
# Script para manejar el cierre de la barra con delay obligatorio
# Evita el flickering y asegura 2 segundos mínimos de apertura

EWW_CONFIG="$HOME/.config/eww"
LOCKFILE="/tmp/eww_bar_lock"
MIN_OPEN_TIME=2  # Segundos mínimos que la barra debe estar abierta

# Crear lockfile con timestamp de apertura
touch "$LOCKFILE"

# Esperar el tiempo mínimo obligatorio
sleep $MIN_OPEN_TIME

# Verificar si el mouse sigue sobre la barra (chequear variable bar_visible)
# Si bar_visible es true (el mouse re-entró), no cerrar
current_state=$(eww -c "$EWW_CONFIG" get bar_visible 2>/dev/null)

if [ "$current_state" = "false" ]; then
    # Solo cerrar si bar_visible sigue siendo false
    eww -c "$EWW_CONFIG" update bar_visible=false
fi

# Limpiar lockfile
rm -f "$LOCKFILE"
