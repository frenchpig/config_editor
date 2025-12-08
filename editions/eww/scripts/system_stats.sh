#!/bin/bash
# Script de estadísticas del sistema para EWW bar
# Usando iconos de Nerd Fonts con códigos Unicode

# Iconos Nerd Fonts usando escape codes
# CPU: nf-md-cpu_64_bit (󰻠) - U+F0EE0 = $'\U000f0ee0'
# RAM: nf-md-memory (󰍛) - U+F035B = $'\U000f035b'  
# Temp: nf-md-thermometer (󰔏) - U+F050F = $'\U000f050f'

ICON_CPU=$'\U000f0ee0'
ICON_RAM=$'\U000f035b'
ICON_TEMP=$'\U000f050f'

# Get CPU usage
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | awk '{printf "%.0f", $1}')

# Get RAM usage
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_avail))
mem_usage=$((mem_used * 100 / mem_total))

# Get Temperature
temp=0
for zone in /sys/class/thermal/thermal_zone*; do
    type=$(cat "$zone/type" 2>/dev/null)
    if [[ "$type" == "x86_pkg_temp" ]] || [[ "$type" == "acpitz" ]]; then
        temp=$(cat "$zone/temp" 2>/dev/null)
        temp=$((temp / 1000))
        break
    fi
done

if [ "$temp" -eq 0 ] && [ -f /sys/class/hwmon/hwmon0/temp1_input ]; then
     temp=$(cat /sys/class/hwmon/hwmon0/temp1_input 2>/dev/null)
     temp=$((temp / 1000))
fi

echo "${ICON_CPU} ${cpu_usage}%  ${ICON_RAM} ${mem_usage}%  ${ICON_TEMP} ${temp}°C"
