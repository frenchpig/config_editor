#!/bin/bash

# Get CPU usage
cpu_usage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}' | awk '{printf "%.0f", $1}')

# Get RAM usage
mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
mem_avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
mem_used=$((mem_total - mem_avail))
mem_usage=$((mem_used * 100 / mem_total))

# Get Temperature (try to find a valid thermal zone)
temp=0
for zone in /sys/class/thermal/thermal_zone*; do
    type=$(cat "$zone/type")
    if [[ "$type" == "x86_pkg_temp" ]] || [[ "$type" == "acpitz" ]]; then
        temp=$(cat "$zone/temp")
        temp=$((temp / 1000))
        break
    fi
done

# If no temp found, try another common one or default to 0
if [ "$temp" -eq 0 ] && [ -f /sys/class/hwmon/hwmon0/temp1_input ]; then
     temp=$(cat /sys/class/hwmon/hwmon0/temp1_input)
     temp=$((temp / 1000))
fi


# Output JSON
# Tooltip shows details
tooltip="CPU: ${cpu_usage}%\nRAM: ${mem_usage}%\nTemp: ${temp}°C"

# Text can be simple or an icon
text=" ${cpu_usage}%   ${mem_usage}%   ${temp}°C"

echo "{\"text\": \"$text\", \"tooltip\": \"$tooltip\", \"class\": \"custom-system\"}"
