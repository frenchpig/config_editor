#!/usr/bin/env bash
# rebuild.sh - Recompila y reinstala la aplicación

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Activar entorno virtual
if [ -d "$BASE_DIR/.venv" ]; then
    echo "Activando entorno virtual..."
    source "$BASE_DIR/.venv/bin/activate"
elif [ -d "$BASE_DIR/venv" ]; then
    echo "Activando entorno virtual..."
    source "$BASE_DIR/venv/bin/activate"
else
    echo "Advertencia: No se encontró entorno virtual (.venv o venv)"
    echo "Asegúrate de tener las dependencias instaladas"
fi

echo "Limpiando compilaciones anteriores..."
rm -rf build/ dist/

echo "Recompilando con PyInstaller..."
pyinstaller ConfigManager.spec

if [ $? -eq 0 ]; then
    echo "Compilación exitosa!"
    
    # Crear directorio de aplicaciones si no existe
    mkdir -p ~/.local/share/applications
    
    # Copiar .desktop actualizado
    cp config-manager.desktop ~/.local/share/applications/
    
    # Actualizar base de datos
    update-desktop-database ~/.local/share/applications/
    
    echo "Aplicación instalada y lista para usar en wofi!"
else
    echo "Error en la compilación"
    exit 1
fi