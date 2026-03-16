#!/bin/bash
#
# apply-dunst.sh - Aplica colores dinámicos a Dunst
# Exit: 0 si exitoso, 1 si falla
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORS_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/validate_colors.sh"

COLORS_FILE="$COLORS_DIR/colors.json"
CONFIG_FILE="$HOME/.config/dunst/dunstrc"

validate_colors "$COLORS_FILE" || {
    echo "Error: colors.json inválido"
    exit 1
}

echo "Aplicando colores a Dunst..."
source "$LIB_DIR/backup.sh" "$CONFIG_FILE"

python3 - "$COLORS_FILE" "$CONFIG_FILE" << 'PYEOF'
import json
import sys
import re

colors_file = sys.argv[1]
config_file = sys.argv[2]

with open(colors_file, 'r') as f:
    colors = json.load(f)

with open(config_file, 'r') as f:
    lines = f.readlines()

bg = colors['special']['background']
fg = colors['special']['foreground']
color1 = colors['colors']['color1']
color3 = colors['colors']['color3']

new_lines = []
in_urgency = False
current_urgency = None

for line in lines:
    # Detectar secciones de urgency
    if line.strip().startswith('[urgency_'):
        if 'low' in line:
            current_urgency = 'low'
        elif 'normal' in line:
            current_urgency = 'normal'
        elif 'critical' in line:
            current_urgency = 'critical'
        else:
            current_urgency = None
        in_urgency = True
        new_lines.append(line)
    elif line.strip().startswith('[') and not line.strip().startswith('[urgency_'):
        in_urgency = False
        current_urgency = None
        new_lines.append(line)
    elif in_urgency and '=' in line:
        key = line.split('=')[0].strip()
        if key == 'foreground':
            new_lines.append(f'foreground = "{fg}"\n')
        elif key == 'background':
            new_lines.append(f'background = "{bg}"\n')
        elif key == 'frame_color':
            if current_urgency == 'low':
                new_lines.append(f'frame_color = "{color3}"\n')
            elif current_urgency == 'normal':
                new_lines.append(f'frame_color = "{color1}"\n')
            elif current_urgency == 'critical':
                new_lines.append(f'frame_color = "{colors["colors"]["color9"]}"\n')
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)
    else:
        new_lines.append(line)

with open(config_file, 'w') as f:
    f.writelines(new_lines)

print('Dunst actualizado')
PYEOF

if [ $? -eq 0 ]; then
    echo "Colores aplicados correctamente"
    exit 0
else
    echo "Error al aplicar colores, restaurando backup..."
    source "$LIB_DIR/restore.sh" "$CONFIG_FILE" || true
    exit 1
fi
