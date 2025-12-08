#!/usr/bin/env bash
# rofi-wifi-menu.sh - Menú WiFi usando rofi/wofi
# Permite escanear y conectarse a redes WiFi

# Detectar si usar rofi o wofi
if command -v rofi &> /dev/null; then
    MENU_CMD="rofi -dmenu -i -p 'WiFi'"
elif command -v wofi &> /dev/null; then
    MENU_CMD="wofi -d -p 'WiFi'"
else
    notify-send "Error" "No se encontró rofi ni wofi"
    exit 1
fi

# Iconos Nerd Fonts
ICON_WIFI=$'\U000f0928'
ICON_LOCK=$'\U000f033e'
ICON_SIGNAL_1=$'\U000f091f'
ICON_SIGNAL_2=$'\U000f0922'
ICON_SIGNAL_3=$'\U000f0925'
ICON_SIGNAL_4=$'\U000f0928'
ICON_DISCONNECT=$'\U000f092d'
ICON_REFRESH=$'\U000f0450'

# Función para obtener icono de señal
get_signal_icon() {
    local signal=$1
    if [ "$signal" -ge 80 ]; then
        echo "$ICON_SIGNAL_4"
    elif [ "$signal" -ge 60 ]; then
        echo "$ICON_SIGNAL_3"
    elif [ "$signal" -ge 40 ]; then
        echo "$ICON_SIGNAL_2"
    else
        echo "$ICON_SIGNAL_1"
    fi
}

# Obtener el estado actual de la conexión WiFi
get_current_connection() {
    nmcli -t -f active,ssid dev wifi | grep '^yes:' | cut -d':' -f2
}

# Función principal del menú
main_menu() {
    current_ssid=$(get_current_connection)
    
    # Opciones del menú
    options=""
    
    # Opción de desconectar si está conectado
    if [ -n "$current_ssid" ]; then
        options="$ICON_DISCONNECT  Desconectar de: $current_ssid\n"
    fi
    
    # Opción de refrescar
    options="${options}$ICON_REFRESH  Escanear redes\n"
    
    # Listar redes disponibles
    wifi_list=$(nmcli -t -f SIGNAL,SECURITY,SSID dev wifi list 2>/dev/null | sort -t':' -k1 -rn | head -15)
    
    while IFS=':' read -r signal security ssid; do
        [ -z "$ssid" ] && continue
        
        signal_icon=$(get_signal_icon "$signal")
        
        if [ "$security" != "--" ] && [ -n "$security" ]; then
            lock_icon="$ICON_LOCK "
        else
            lock_icon="  "
        fi
        
        # Marcar la red conectada
        if [ "$ssid" = "$current_ssid" ]; then
            options="${options}${signal_icon} ${lock_icon}${ssid} (conectado)\n"
        else
            options="${options}${signal_icon} ${lock_icon}${ssid}\n"
        fi
    done <<< "$wifi_list"
    
    # Mostrar menú
    chosen=$(echo -e "$options" | $MENU_CMD)
    
    # Procesar selección
    if [ -z "$chosen" ]; then
        exit 0
    fi
    
    if echo "$chosen" | grep -q "Desconectar"; then
        nmcli device disconnect wlan0 2>/dev/null || nmcli device disconnect wlp2s0 2>/dev/null
        notify-send "WiFi" "Desconectado de $current_ssid"
        
    elif echo "$chosen" | grep -q "Escanear"; then
        notify-send "WiFi" "Escaneando redes..."
        nmcli dev wifi rescan 2>/dev/null
        sleep 2
        main_menu
        
    else
        # Extraer SSID (quitar icono y estado)
        selected_ssid=$(echo "$chosen" | sed 's/^[^ ]* *[^ ]* *//' | sed 's/ (conectado)$//')
        
        if [ "$selected_ssid" = "$current_ssid" ]; then
            notify-send "WiFi" "Ya estás conectado a $selected_ssid"
            exit 0
        fi
        
        # Verificar si la red tiene contraseña guardada
        saved=$(nmcli -t -f NAME connection show | grep -F "$selected_ssid")
        
        if [ -n "$saved" ]; then
            # Intentar conectar con credenciales guardadas
            nmcli connection up "$selected_ssid" && \
                notify-send "WiFi" "Conectado a $selected_ssid" || \
                notify-send "WiFi" "Error al conectar a $selected_ssid"
        else
            # Pedir contraseña
            if command -v rofi &> /dev/null; then
                password=$(rofi -dmenu -password -p "Contraseña para $selected_ssid")
            else
                password=$(wofi -d -P -p "Contraseña para $selected_ssid")
            fi
            
            if [ -n "$password" ]; then
                nmcli dev wifi connect "$selected_ssid" password "$password" && \
                    notify-send "WiFi" "Conectado a $selected_ssid" || \
                    notify-send "WiFi" "Error al conectar. Verifica la contraseña."
            fi
        fi
    fi
}

main_menu
