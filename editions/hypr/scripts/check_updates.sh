#!/bin/bash
# Script para verificar actualizaciones disponibles al iniciar el sistema
# Se ejecuta una sola vez y muestra una notificación

# Esperar un poco para que el sistema esté completamente iniciado
sleep 10

# Verificar si checkupdates está disponible, si no usar pacman
if command -v checkupdates &> /dev/null; then
    # Usar checkupdates (más seguro, no necesita sudo)
    UPDATES=$(checkupdates 2>/dev/null)
else
    # Alternativa: sincronizar base de datos y contar paquetes
    # Crear directorio temporal para la base de datos
    TMPDIR=$(mktemp -d)
    
    # Copiar la base de datos actual
    cp -r /var/lib/pacman/sync "$TMPDIR/"
    
    # Sincronizar en la ubicación temporal
    fakeroot -- pacman -Sy --dbpath "$TMPDIR" &>/dev/null
    
    # Obtener lista de actualizaciones
    UPDATES=$(pacman -Qu --dbpath "$TMPDIR" 2>/dev/null)
    
    # Limpiar directorio temporal
    rm -rf "$TMPDIR"
fi

# Contar actualizaciones
if [ -n "$UPDATES" ]; then
    COUNT=$(echo "$UPDATES" | wc -l)
    
    if [ "$COUNT" -eq 1 ]; then
        notify-send -i software-update-available "Actualización disponible" "Hay 1 paquete disponible para actualizar"
    else
        notify-send -i software-update-available "Actualizaciones disponibles" "Hay $COUNT paquetes disponibles para actualizar"
    fi
else
    # Opcional: notificar que el sistema está actualizado
    # Descomenta la siguiente línea si quieres esta notificación
    # notify-send -i software-update-available "Sistema actualizado" "No hay actualizaciones pendientes"
    :
fi
