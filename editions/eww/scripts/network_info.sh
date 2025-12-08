#!/bin/bash
# Script para obtener información de red para EWW bar
# Usando iconos de Nerd Fonts con códigos Unicode

# Iconos Nerd Fonts
# WiFi: nf-md-wifi (󰤨) - U+F0928
# Ethernet: nf-md-ethernet (󰈀) - U+F0200
# Disconnected: nf-md-wifi_off (󰤭) - U+F092D

ICON_WIFI=$'\U000f0928'
ICON_ETHERNET=$'\U000f0200'
ICON_DISCONNECTED=$'\U000f092d'

# Verificar conexión WiFi activa
wifi_device=$(nmcli -t -f TYPE,DEVICE,STATE device status | grep '^wifi:' | head -n1)

if echo "$wifi_device" | grep -q ':connected'; then
    device_name=$(echo "$wifi_device" | cut -d':' -f2)
    ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes:' | cut -d':' -f2 | head -n1)
    
    if [ -z "$ssid" ]; then
        ssid=$(nmcli -t -f NAME,DEVICE connection show --active 2>/dev/null | grep ":$device_name" | cut -d':' -f1 | head -n1)
    fi
    
    [ -z "$ssid" ] && ssid="WiFi"
    echo "${ICON_WIFI} ${ssid}"
    exit 0
fi

# Verificar Ethernet
eth_device=$(nmcli -t -f TYPE,DEVICE,STATE device status | grep '^ethernet:')
if echo "$eth_device" | grep -q ':connected'; then
    echo "${ICON_ETHERNET} Ethernet"
    exit 0
fi

echo "${ICON_DISCONNECTED} Sin Red"
