#!/bin/bash
#
# apply-alacritty.sh - Aplica colores dinámicos a Alacritty
# Substitution-only: reemplaza solo colores en config del usuario
# Exit: 0 si exitoso, 1 si falla
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORS_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/validate_colors.sh"

COLORS_FILE="$COLORS_DIR/colors.json"
CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

# =====================
# VALIDACIONES
# =====================

validate_colors "$COLORS_FILE" || {
    echo "Error: colors.json inválido"
    exit 1
}

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config de Alacritty no encontrada: $CONFIG_FILE"
    exit 1
fi

# =====================
# APLICAR COLORES (SUBSTITUTION-ONLY)
# =====================

echo "Aplicando colores a Alacritty..."

# Backup
source "$LIB_DIR/backup.sh" "$CONFIG_FILE"

# Python: substitution solo en colores, preservando resto del archivo
python3 - "$COLORS_FILE" "$CONFIG_FILE" << 'PYEOF'
import json
import sys
import re

colors_file = sys.argv[1]
config_file = sys.argv[2]

# Cargar colores desde pywal format (#RRGGBB)
with open(colors_file, 'r') as f:
    colors = json.load(f)

# Función: convertir #RRGGBB → 0xRRGGBB
def to_alacritty_color(hex_color):
    if hex_color.startswith('0x'):
        return hex_color  # Ya está en formato Alacritty
    if hex_color.startswith('#'):
        return '0x' + hex_color[1:]  # Convertir #RRGGBB → 0xRRGGBB
    return hex_color

# Mapeo de colores pywal → Alacritty
color_map = {
    'color0': to_alacritty_color(colors['colors']['color0']),
    'color1': to_alacritty_color(colors['colors']['color1']),
    'color2': to_alacritty_color(colors['colors']['color2']),
    'color3': to_alacritty_color(colors['colors']['color3']),
    'color4': to_alacritty_color(colors['colors']['color4']),
    'color5': to_alacritty_color(colors['colors']['color5']),
    'color6': to_alacritty_color(colors['colors']['color6']),
    'color7': to_alacritty_color(colors['colors']['color7']),
    'color8': to_alacritty_color(colors['colors']['color8']),
    'color9': to_alacritty_color(colors['colors']['color9']),
    'color10': to_alacritty_color(colors['colors']['color10']),
    'color11': to_alacritty_color(colors['colors']['color11']),
    'color12': to_alacritty_color(colors['colors']['color12']),
    'color13': to_alacritty_color(colors['colors']['color13']),
    'color14': to_alacritty_color(colors['colors']['color14']),
    'color15': to_alacritty_color(colors['colors']['color15']),
}

bg = to_alacritty_color(colors['special']['background'])
fg = to_alacritty_color(colors['special']['foreground'])
cursor = to_alacritty_color(colors['special']['cursor'])

# Leer config del usuario (no template!)
with open(config_file, 'r') as f:
    lines = f.readlines()

# Procesar línea por línea, substitution solo en secciones [colors.*]
new_lines = []
section = None

for line in lines:
    original = line
    
    # Detectar sección
    if line.strip().startswith('['):
        if 'colors.bright' in line:
            section = 'bright'
        elif 'colors.normal' in line:
            section = 'normal'
        elif 'colors.cursor' in line:
            section = 'cursor'
        elif 'colors.primary' in line:
            section = 'primary'
        else:
            section = None
        new_lines.append(line)
        continue
    
    # Substitution según sección
    if section == 'bright' and '=' in line:
        key = line.split('=')[0].strip()
        if key == 'black':
            new_lines.append(f'black = "{color_map["color8"]}"\n')
        elif key == 'red':
            new_lines.append(f'red = "{color_map["color9"]}"\n')
        elif key == 'green':
            new_lines.append(f'green = "{color_map["color10"]}"\n')
        elif key == 'yellow':
            new_lines.append(f'yellow = "{color_map["color11"]}"\n')
        elif key == 'blue':
            new_lines.append(f'blue = "{color_map["color12"]}"\n')
        elif key == 'magenta':
            new_lines.append(f'magenta = "{color_map["color13"]}"\n')
        elif key == 'cyan':
            new_lines.append(f'cyan = "{color_map["color14"]}"\n')
        elif key == 'white':
            new_lines.append(f'white = "{color_map["color15"]}"\n')
        else:
            new_lines.append(line)
            
    elif section == 'normal' and '=' in line:
        key = line.split('=')[0].strip()
        if key == 'black':
            new_lines.append(f'black = "{color_map["color0"]}"\n')
        elif key == 'red':
            new_lines.append(f'red = "{color_map["color1"]}"\n')
        elif key == 'green':
            new_lines.append(f'green = "{color_map["color2"]}"\n')
        elif key == 'yellow':
            new_lines.append(f'yellow = "{color_map["color3"]}"\n')
        elif key == 'blue':
            new_lines.append(f'blue = "{color_map["color4"]}"\n')
        elif key == 'magenta':
            new_lines.append(f'magenta = "{color_map["color5"]}"\n')
        elif key == 'cyan':
            new_lines.append(f'cyan = "{color_map["color6"]}"\n')
        elif key == 'white':
            new_lines.append(f'white = "{color_map["color7"]}"\n')
        else:
            new_lines.append(line)
            
    elif section == 'cursor' and '=' in line:
        key = line.split('=')[0].strip()
        if key == 'cursor':
            new_lines.append(f'cursor = "{cursor}"\n')
        elif key == 'text':
            new_lines.append(f'text = "{bg}"\n')
        else:
            new_lines.append(line)
            
    elif section == 'primary' and '=' in line:
        key = line.split('=')[0].strip()
        if key == 'background':
            new_lines.append(f'background = "{bg}"\n')
        elif key == 'foreground':
            new_lines.append(f'foreground = "{fg}"\n')
        else:
            new_lines.append(line)
    else:
        # Preservar línea sin cambios
        new_lines.append(line)

# Escribir resultado al archivo del usuario
with open(config_file, 'w') as f:
    f.writelines(new_lines)

print('Alacritty actualizado (substitution-only)')
PYEOF

if [ $? -eq 0 ]; then
    echo "Colores aplicados correctamente"
    exit 0
else
    echo "Error al aplicar colores, restaurando backup..."
    source "$LIB_DIR/restore.sh" "$CONFIG_FILE" || true
    exit 1
fi
