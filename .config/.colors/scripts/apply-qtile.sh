#!/bin/bash
#
# apply-qtile.sh - Aplica colores dinámicos a Qtile
# Exit: 0 si exitoso, 1 si falla
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORS_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/validate_colors.sh"

COLORS_FILE="$COLORS_DIR/colors.json"
CONFIG_FILE="$HOME/.config/qtile/themes/wallust.json"
QTILE_CONFIG="$HOME/.config/qtile/config.json"

validate_colors "$COLORS_FILE" || {
    echo "Error: colors.json inválido"
    exit 1
}

# Crear directorio si no existe
mkdir -p "$(dirname "$CONFIG_FILE")"

echo "Aplicando colores a Qtile..."
source "$LIB_DIR/backup.sh" "$CONFIG_FILE"

python3 - "$COLORS_FILE" "$CONFIG_FILE" << 'PYEOF'
import json
import sys

colors_file = sys.argv[1]
config_file = sys.argv[2]

with open(colors_file, 'r') as f:
    colors = json.load(f)

# Crear theme JSON para Qtile siguiendo formato trainatlas/kronii
bg = colors['special']['background']
fg = colors['special']['foreground']
c8 = colors['colors']['color8']
c7 = colors['colors']['color7']
c4 = colors['colors']['color4']
c5 = colors['colors']['color5']
c1 = colors['colors']['color1']
c2 = colors['colors']['color2']
c3 = colors['colors']['color3']

theme = {
    "dark": [bg, bg],
    "grey": [c8, c8],
    "light": [c7, c7],
    "text": [fg, fg],
    "focus": [c4, c4],
    "urgent": [c1, c1],
    "active": [c5, c5],
    "inactive": [c8, c8],
    "color1": [c1, c1],
    "color2": [c2, c2],
    "color3": [c3, c3],
    "color4": [c4, c4],
    "alpha": ["#00000000", "#00000000"],
}

with open(config_file, 'w') as f:
    json.dump(theme, f, indent=4)

print('Qtile theme actualizado')
PYEOF

if [ $? -eq 0 ]; then
    # Actualizar config.json para usar wallust
    echo '{"theme": "wallust"}' > "$QTILE_CONFIG"
    echo "Colores aplicados correctamente"
    echo "Qtile theme: wallust (actualizado en config.json)"
    exit 0
else
    echo "Error al aplicar colores, restaurando backup..."
    source "$LIB_DIR/restore.sh" "$CONFIG_FILE" || true
    exit 1
fi
