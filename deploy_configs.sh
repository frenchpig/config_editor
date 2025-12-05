#!/usr/bin/env bash
# deploy_configs.sh
# Despliega todas las configuraciones desde editions/ a ~/.config/
# Incluye: hypr, wofi, wleave, kitty, waybar, mako, eww, etc.

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
  
  # Caso especial: dolphinrc debe copiarse como archivo, no como directorio
  if [ "$name" = "dolphin" ] && [ -f "$src/dolphinrc" ]; then
    target="$USER_HOME/$CONFIG_DIR/dolphinrc"
    
    # Hacer backup de config actual si existe
    if [ -e "$target" ]; then
      backup="${target}.bak_$(date +%Y%m%d_%H%M)"
      mv "$target" "$backup"
      echo "Backup de config existente: $target → $backup"
    fi
    
    cp -a "$src/dolphinrc" "$target"
    echo "Instalado: $src/dolphinrc → $target"
    
    # Desplegar qt6ct.conf si existe
    if [ -f "$src/qt6ct.conf" ]; then
      qt6ct_dir="$USER_HOME/$CONFIG_DIR/qt6ct"
      mkdir -p "$qt6ct_dir"
      qt6ct_target="$qt6ct_dir/qt6ct.conf"
      
      if [ -e "$qt6ct_target" ]; then
        backup="${qt6ct_target}.bak_$(date +%Y%m%d_%H%M)"
        mv "$qt6ct_target" "$backup"
        echo "Backup de config existente: $qt6ct_target → $backup"
      fi
      
      # Actualizar ruta del esquema de colores en qt6ct.conf
      sed "s|color_scheme_path=.*|color_scheme_path=$qt6ct_dir/colors/FrutigerAero.conf|" "$src/qt6ct.conf" > "$qt6ct_target"
      echo "Instalado: $src/qt6ct.conf → $qt6ct_target"
    fi
    
    # Desplegar esquema de colores si existe
    if [ -d "$src/colors" ]; then
      colors_target_dir="$USER_HOME/$CONFIG_DIR/qt6ct/colors"
      mkdir -p "$colors_target_dir"
      
      if [ -e "$colors_target_dir" ]; then
        for color_file in "$src/colors"/*; do
          if [ -f "$color_file" ]; then
            color_name=$(basename "$color_file")
            cp -a "$color_file" "$colors_target_dir/$color_name"
            echo "Instalado: $color_file → $colors_target_dir/$color_name"
          fi
        done
      fi
    fi
  # Caso especial: gtk-3.0 y gtk-4.0 - eliminar assets/ personalizados
  elif [ "$name" = "gtk-3.0" ] || [ "$name" = "gtk-4.0" ]; then
    target="$USER_HOME/$CONFIG_DIR/$name"

    # Hacer backup de config actual si existe
    if [ -e "$target" ]; then
      backup="${target}.bak_$(date +%Y%m%d_%H%M)"
      mv "$target" "$backup"
      echo "Backup de config existente: $target → $backup"
    fi

    # Crear directorio destino
    mkdir -p "$target"
    
    # Copiar solo archivos de configuración, no assets/
    for file in "$src"/*; do
      if [ -f "$file" ]; then
        cp -a "$file" "$target/"
        echo "Instalado: $file → $target/$(basename "$file")"
      fi
    done
    
    # Eliminar assets/ si existe en destino (resetear a valores por defecto)
    if [ -d "$target/assets" ]; then
      rm -rf "$target/assets"
      echo "Eliminado: $target/assets (resetear a valores por defecto)"
    fi
  else
    target="$USER_HOME/$CONFIG_DIR/$name"

    # Hacer backup de config actual si existe
    if [ -e "$target" ]; then
      backup="${target}.bak_$(date +%Y%m%d_%H%M)"
      mv "$target" "$backup"
      echo "Backup de config existente: $target → $backup"
    fi

    cp -a "$src" "$target"
    echo "Instalado: $src → $target"
  fi
done

echo "Despliegue completado."
