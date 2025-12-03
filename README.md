# Config Manager

Gestor de configuraciones con interfaz gráfica para administrar configuraciones de aplicaciones de escritorio Linux (Hyprland, Kitty, Waybar, Mako, Wofi, Wleave, etc.).

## Características

- **Interfaz gráfica** con tema oscuro usando Tkinter
- **Backup automático** de configuraciones existentes
- **Despliegue** de configuraciones desde el directorio `editions/`
- **Restauración** de backups anteriores
- **Gestión automática** de backups (mantiene máximo 5 backups)

## Estructura del Proyecto

```
config_editor/
├── config_manager.py      # Aplicación principal con GUI
├── backup_configs.sh      # Script para crear backups
├── deploy_configs.sh      # Script para desplegar configuraciones
├── restore_configs.sh     # Script para restaurar backups
├── editions/              # Configuraciones editables
│   ├── hypr/
│   ├── kitty/
│   ├── waybar/
│   ├── mako/
│   ├── wofi/
│   └── wleave/
└── backups/               # Backups automáticos (ignorado por git)
```

## Requisitos

- Python 3.x
- Tkinter (generalmente incluido con Python)
- python-dotenv (instalar con `pip install -r requirements.txt`)
- Bash
- Aplicaciones de configuración: Hyprland, Kitty, Waybar, Mako, Wofi, Wleave

## Configuración

Antes de usar la aplicación, configura las variables de entorno:

1. Copia el archivo de ejemplo:
```bash
cp .env.example .env
```

2. Edita `.env` según tus necesidades:
   - `USER_HOME`: Directorio home del usuario (dejar vacío para usar `$HOME`)
   - `CONFIG_DIR`: Directorio de configuraciones (por defecto: `.config`)
   - `CONFIG_APPS`: Lista de aplicaciones a gestionar (separadas por espacios o comas)
   - `MAX_BACKUPS`: Número máximo de backups a mantener (por defecto: 5)

Ejemplo de `.env`:
```env
USER_HOME=
CONFIG_DIR=.config
CONFIG_APPS=hypr wofi wleave kitty waybar mako
MAX_BACKUPS=5
```

## Uso

### Instalación de dependencias

```bash
pip install -r requirements.txt
```

### Ejecutar la aplicación

```bash
python config_manager.py
```

### Compilar con PyInstaller

```bash
pyinstaller ConfigManager.spec
```

El ejecutable se generará en `dist/ConfigManager`.

### Scripts manuales

- **Backup**: `./backup_configs.sh` - Crea un backup de las configuraciones actuales
- **Deploy**: `./deploy_configs.sh` - Despliega configuraciones desde `editions/` a `~/.config/`
- **Restore**: Usar la interfaz gráfica para restaurar backups

## Funcionalidades

### Backup
- Crea un backup con timestamp de todas las configuraciones
- Mantiene máximo 5 backups (elimina los más antiguos automáticamente)
- Copia las configuraciones a `editions/` para edición

### Deploy
- Despliega todas las configuraciones desde `editions/` a `~/.config/`
- Crea backup automático de configuraciones existentes antes de sobrescribir

### Restore
- Lista todos los backups disponibles
- Permite restaurar cualquier backup anterior
- Crea backup de la configuración actual antes de restaurar

## Configuraciones Soportadas

- **Hyprland** (`~/.config/hypr`)
- **Kitty** (`~/.config/kitty`)
- **Waybar** (`~/.config/waybar`)
- **Mako** (`~/.config/mako`)
- **Wofi** (`~/.config/wofi`)
- **Wleave** (`~/.config/wleave`)

## Notas

- Los backups se almacenan en `backups/` con formato de fecha `YYYY-MM-DD_HHMM`
- El directorio `backups/` está excluido del control de versiones
- Las configuraciones editables están en `editions/` y pueden ser versionadas

