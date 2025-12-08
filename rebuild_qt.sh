#!/usr/bin/env bash
# rebuild_qt.sh - Recompila y reinstala la aplicación PyQt6

set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "═══════════════════════════════════════════════════════"
echo "  Config Manager Qt - Build Script"
echo "═══════════════════════════════════════════════════════"

# Activar entorno virtual
if [ -d "$BASE_DIR/.venv" ]; then
    echo "✓ Activando entorno virtual (.venv)..."
    source "$BASE_DIR/.venv/bin/activate"
elif [ -d "$BASE_DIR/venv" ]; then
    echo "✓ Activando entorno virtual (venv)..."
    source "$BASE_DIR/venv/bin/activate"
else
    echo "⚠ Advertencia: No se encontró entorno virtual (.venv o venv)"
    echo "  Asegúrate de tener las dependencias instaladas"
fi

# Instalar/actualizar dependencias
if [ -f "$BASE_DIR/requirements.txt" ]; then
    echo "✓ Instalando dependencias..."
    pip install -r requirements.txt --quiet --upgrade
fi

echo "✓ Limpiando compilaciones anteriores..."
rm -rf build/ dist/

# Generar spec file para PyQt6
echo "✓ Generando spec file..."
cat > "$BASE_DIR/ConfigManagerQt.spec" << 'EOF'
# -*- mode: python ; coding: utf-8 -*-
# ConfigManagerQt.spec - PyInstaller spec for PyQt6 version

block_cipher = None

a = Analysis(
    ['config_manager_qt.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[
        'PyQt6',
        'PyQt6.QtCore',
        'PyQt6.QtGui',
        'PyQt6.QtWidgets',
        'PyQt6.sip',
        'dotenv',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='ConfigManagerQt',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
EOF

echo "✓ Recompilando con PyInstaller..."
pyinstaller ConfigManagerQt.spec

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  ✓ Compilación exitosa!"
    echo "═══════════════════════════════════════════════════════"
    
    # Crear directorio de aplicaciones si no existe
    mkdir -p ~/.local/share/applications
    
    # Copiar .desktop actualizado
    cp config-manager.desktop ~/.local/share/applications/
    
    # Actualizar base de datos
    update-desktop-database ~/.local/share/applications/ 2>/dev/null || true
    
    echo ""
    echo "  El ejecutable está en: dist/ConfigManagerQt"
    echo "  Aplicación instalada y lista para usar en wofi!"
    echo ""
else
    echo ""
    echo "═══════════════════════════════════════════════════════"
    echo "  ✗ Error en la compilación"
    echo "═══════════════════════════════════════════════════════"
    exit 1
fi

