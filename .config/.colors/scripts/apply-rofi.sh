#!/bin/bash
#
# apply-rofi.sh - Aplica colores dinámicos a Rofi
# Modifica directamente tokyonight.rasi con los colores del wallpaper
# Exit: 0 si exitoso, 1 si falla
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORS_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/validate_colors.sh"

COLORS_FILE="$COLORS_DIR/colors.json"
THEME_FILE="$HOME/.config/rofi/tokyonight.rasi"
CONFIG_FILE="$HOME/.config/rofi/config.rasi"

validate_colors "$COLORS_FILE" || {
    echo "Error: colors.json inválido"
    exit 1
}

echo "Aplicando colores a Rofi..."

# Backup del theme original
source "$LIB_DIR/backup.sh" "$THEME_FILE"

# Modificar tokyonight.rasi con los colores usando line-parsing
python3 - "$COLORS_FILE" "$THEME_FILE" << 'PYEOF'
import json
import sys
import re
import os

colors_file = sys.argv[1]
theme_file = sys.argv[2]

def validate_color(color: str) -> bool:
    """Valida que el color tenga formato #RRGGBB"""
    return bool(re.match(r'^#[0-9a-fA-F]{6}$', color))

def verify_replacement(content: str, colors_map: dict) -> bool:
    """Verifica que todos los colores fueron reemplazados"""
    for expected_color in colors_map.values():
        if expected_color not in content:
            return False
    return True

# Cargar colores
with open(colors_file, 'r') as f:
    colors = json.load(f)

# Mapear colores de pywal a Rofi
colors_map = {
    'bg': colors['special']['background'],
    'bg-alt': colors['colors']['color8'],
    'fg': colors['special']['foreground'],
    'fg-alt': colors['colors']['color7']
}

# Validar que todos los colores tengan formato correcto
for color_var, color_value in colors_map.items():
    if not validate_color(color_value):
        print(f"Error: Formato de color inválido para {color_var}: {color_value}")
        sys.exit(1)

# Leer theme file
with open(theme_file, 'r') as f:
    content = f.read()

# Reemplazar cada color usando regex (line-parsing approach)
for color_var, new_color in colors_map.items():
    content = re.sub(
        rf'^(\s*{color_var}:\s*)#[0-9a-fA-F]{{6}}(;)',
        rf'\g<1>{new_color}\g<2>',
        content,
        flags=re.MULTILINE
    )

# Verificar que todos los colores fueron reemplazados
if not verify_replacement(content, colors_map):
    print("Error: Falló la verificación de substitución de colores")
    sys.exit(1)

# Escribir theme actualizado
with open(theme_file, 'w') as f:
    f.write(content)

print(f"Theme actualizado correctamente: {theme_file}")
PYEOF

# Verificar que el script de Python terminó bien
if [ $? -ne 0 ]; then
    echo "Error: Falló la aplicación de colores a Rofi"
    exit 1
fi

# Actualizar config.rasi para usar tokyonight
if [ -f "$CONFIG_FILE" ]; then
    sed -i 's/@theme[[:space:]]*"[^"]*"/@theme "tokyonight"/' "$CONFIG_FILE"
fi

echo "Colores aplicados correctamente a Rofi"
exit 0
