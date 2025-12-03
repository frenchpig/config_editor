#!/usr/bin/env bash
# restore_configs.sh
# Restaura configuraciones desde backups/ a ~/.config/
# Incluye todas las configuraciones del backup: hypr, wofi, wleave, kitty, waybar, mako, etc.

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Cargar variables de entorno desde .env
if [ -f "$BASE_DIR/load_env.sh" ]; then
    source "$BASE_DIR/load_env.sh"
    load_env ".env" "$BASE_DIR"
fi

# Configurar valores por defecto si no están definidos
USER_HOME="${USER_HOME:-$HOME}"
CONFIG_DIR="${CONFIG_DIR:-.config}"

BACKUP_ROOT="$BASE_DIR/backups"

if [ ! -d "$BACKUP_ROOT" ]; then
  echo "ERROR: no existe carpeta de backups: $BACKUP_ROOT"
  exit 1
fi

echo "Backups disponibles:"
ls "$BACKUP_ROOT"

echo
read -p "Ingresa el nombre de la carpeta de backup a restaurar: " choice

SRC_DIR="$BACKUP_ROOT/$choice"
if [ ! -d "$SRC_DIR" ]; then
  echo "ERROR: la carpeta seleccionada no existe: $SRC_DIR"
  exit 1
fi

echo "Restaurando desde: $SRC_DIR"

for src in "$SRC_DIR"/*; do
  name=$(basename "$src")
  target="$USER_HOME/$CONFIG_DIR/$name"
  if [ -e "$target" ]; then
    mv "$target" "${target}.old_$(date +%Y%m%d_%H%M)"
    echo "Guardado config actual: $target → ${target}.old_…"
  fi
  cp -a "$src" "$target"
  echo "Restaurado: $src → $target"
done

echo "Restauración completada."
