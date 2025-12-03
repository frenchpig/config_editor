#!/usr/bin/env bash
# load_env.sh
# Función helper para cargar variables de entorno desde .env

load_env() {
    local env_file="${1:-.env}"
    local base_dir="${2:-$(cd "$(dirname "$0")" && pwd)}"
    local env_path="$base_dir/$env_file"
    
    if [ ! -f "$env_path" ]; then
        # Si no existe .env, usar valores por defecto
        return 0
    fi
    
    # Leer el archivo .env línea por línea
    while IFS= read -r line || [ -n "$line" ]; do
        # Ignorar comentarios y líneas vacías
        if [[ "$line" =~ ^[[:space:]]*# ]] || [[ -z "${line// }" ]]; then
            continue
        fi
        
        # Extraer clave y valor (soporta formato KEY=value y KEY="value")
        if [[ "$line" =~ ^[[:space:]]*([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]// /}"
            local value="${BASH_REMATCH[2]}"
            
            # Remover comillas si existen
            value="${value#\"}"
            value="${value%\"}"
            value="${value#\'}"
            value="${value%\'}"
            
            # Remover espacios en blanco al inicio y final
            value="${value#"${value%%[![:space:]]*}"}"
            value="${value%"${value##*[![:space:]]}"}"
            
            # Exportar variable si no está ya definida
            if [ -z "${!key}" ]; then
                export "$key=$value"
            fi
        fi
    done < "$env_path"
}

