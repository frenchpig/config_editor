#!/usr/bin/env bash
# backup_configs.sh

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

# Cargar variables de entorno desde .env
if [ -f "$BASE_DIR/load_env.sh" ]; then
    source "$BASE_DIR/load_env.sh"
    load_env ".env" "$BASE_DIR"
fi

# Configurar valores por defecto si no están definidos
USER_HOME="${USER_HOME:-$HOME}"
CONFIG_DIR="${CONFIG_DIR:-.config}"
MAX_BACKUPS="${MAX_BACKUPS:-5}"

# Parsear CONFIG_APPS (soporta espacios o comas)
if [ -z "$CONFIG_APPS" ]; then
    # Valores por defecto si no se especifica
    CONFIG_APPS="hypr wofi wleave kitty waybar mako"
fi

# Convertir CONFIG_APPS a array, soportando espacios y comas
IFS=', ' read -ra APPS_ARRAY <<< "$CONFIG_APPS"

BACKUP_ROOT="$BASE_DIR/backups"
EDITIONS_ROOT="$BASE_DIR/editions"
DATE=$(date +"%Y-%m-%d_%H%M")

mkdir -p "$BACKUP_ROOT/$DATE"
mkdir -p "$EDITIONS_ROOT"
if [ -d "$BACKUP_ROOT" ]; then
  # Contar backups existentes (carpetas con formato de fecha YYYY-MM-DD_HHMM)
  backup_count=$(find "$BACKUP_ROOT" -maxdepth 1 -type d -name "*-*_*" | wc -l)
  if [ "$backup_count" -ge "$MAX_BACKUPS" ]; then
    # Calcular cuántos eliminar (mantener MAX_BACKUPS - 1 para dejar espacio al nuevo)
    to_remove=$((backup_count - MAX_BACKUPS + 1))
    # Encontrar los backups más viejos (ordenados por nombre) y eliminarlos
    find "$BACKUP_ROOT" -maxdepth 1 -type d -name "*-*_*" | sort | head -n "$to_remove" | while read -r old_backup; do
      if [ -n "$old_backup" ]; then
        echo "Eliminando backup viejo: $(basename "$old_backup")"
        rm -rf "$old_backup"
      fi
    done
  fi
fi

echo "Creando respaldo en: $BACKUP_ROOT/$DATE"
echo "Creando copia editable en: $EDITIONS_ROOT"
echo "Usuario: $USER_HOME"
echo "Directorio de config: $CONFIG_DIR"
echo "Aplicaciones: ${CONFIG_APPS}"

for app in "${APPS_ARRAY[@]}"; do
  # Limpiar espacios en blanco
  app=$(echo "$app" | xargs)
  if [ -z "$app" ]; then
    continue
  fi
  
  # Caso especial: dolphinrc es un archivo, no un directorio
  if [ "$app" = "dolphin" ]; then
    src="$USER_HOME/$CONFIG_DIR/dolphinrc"
    name="dolphin"
    
    if [ -e "$src" ]; then
      # Crear directorio dolphin en backup
      dest_dir="$BACKUP_ROOT/$DATE/$name"
      mkdir -p "$dest_dir"
      dest="$dest_dir/dolphinrc"
      cp -a "$src" "$dest"
      echo "Respaldado: $src → $dest"

      # Copia editable
      edit_dest_dir="$EDITIONS_ROOT/$name"
      mkdir -p "$edit_dest_dir"
      edit_dest="$edit_dest_dir/dolphinrc"
      if [ -e "$edit_dest" ]; then
        rm -f "$edit_dest"
      fi
      cp -a "$src" "$edit_dest"
      echo "Copiado a editable: $src → $edit_dest"
    else
      echo "No existe: $src  — saltando"
    fi
  else
    src="$USER_HOME/$CONFIG_DIR/$app"
    name="$app"

    if [ -e "$src" ]; then
      # Copia de respaldo
      dest="$BACKUP_ROOT/$DATE/$name"
      cp -a "$src" "$dest"
      echo "Respaldado: $src → $dest"

      # Copia editable (sobrescribe directamente sin crear backups)
      edit_dest="$EDITIONS_ROOT/$name"
      # Eliminar si existe para evitar conflictos
      if [ -e "$edit_dest" ]; then
        rm -rf "$edit_dest"
      fi
      cp -a "$src" "$edit_dest"
      echo "Copiado a editable: $src → $edit_dest"
    else
      echo "No existe: $src  — saltando"
    fi
  fi
done

echo "Backup + copia editable completados."
