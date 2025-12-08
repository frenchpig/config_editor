#!/bin/bash
# Script para abrir/cerrar widgets de manera exclusiva
# Solo un widget puede estar abierto a la vez
# También mantiene la barra visible mientras el widget esté abierto

EWW_CONFIG="$HOME/.config/eww"
WIDGET_NAME="$1"

# Lista de widgets popup (excluyendo la barra)
POPUP_WIDGETS="volume_control brightness_control power_profile"

# Verificar si el widget solicitado está abierto usando active-windows
is_open=$(eww -c "$EWW_CONFIG" active-windows | grep "^${WIDGET_NAME}:")

if [ -n "$is_open" ]; then
    # Widget está abierto, solo cerrarlo
    eww -c "$EWW_CONFIG" close "$WIDGET_NAME"
    exit 0
fi

# Widget no está abierto, cerrar todos los otros widgets popup primero
for w in $POPUP_WIDGETS; do
    if [ "$w" != "$WIDGET_NAME" ]; then
        eww -c "$EWW_CONFIG" close "$w" 2>/dev/null
    fi
done

# Abrir el widget solicitado
eww -c "$EWW_CONFIG" open "$WIDGET_NAME"

# Mantener la barra visible mientras el widget esté abierto
eww -c "$EWW_CONFIG" update bar_visible=true bar_hover=true
