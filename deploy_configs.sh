#!/usr/bin/env bash
# deploy_configs.sh
# Despliega todas las configuraciones desde editions/ a ~/.config/
# Incluye: hypr, wofi, wleave, kitty, waybar, mako, etc.

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Cargar variables de entorno desde .env
if [ -f "$BASE_DIR/load_env.sh" ]; then
    source "$BASE_DIR/load_env.sh"
    load_env ".env" "$BASE_DIR"
fi

# Configurar valores por defecto si no están definidos
USER_HOME="${USER_HOME:-$HOME}"
CONFIG_DIR="${CONFIG_DIR:-.config}"

SRC_ROOT="$BASE_DIR/editions"

if [ ! -d "$SRC_ROOT" ]; then
  echo "ERROR: no existe carpeta de ediciones: $SRC_ROOT"
  exit 1
fi

echo "Desplegando configuraciones desde: $SRC_ROOT"
echo "Usuario: $USER_HOME"
echo "Directorio de config: $CONFIG_DIR"

for src in "$SRC_ROOT"/*; do
  name=$(basename "$src")
  target="$USER_HOME/$CONFIG_DIR/$name"

  # Hacer backup de config actual si existe
  if [ -e "$target" ]; then
    backup="${target}.bak_$(date +%Y%m%d_%H%M)"
    mv "$target" "$backup"
    echo "Backup de config existente: $target → $backup"
  fi

  cp -a "$src" "$target"
  echo "Instalado: $src → $target"
done

echo "Despliegue completado."
