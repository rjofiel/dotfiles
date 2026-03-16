#!/bin/bash
#
# generate.sh - Genera colors.json desde un wallpaper
# Usage: generate.sh [-e engine] <wallpaper_path>
# Engines: wallust (default), wal
# Output: ~/.config/.colors/colors.json
# Exit: 0 si exitoso, 1 si falla
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COLORS_DIR="$(dirname "$SCRIPT_DIR")"
LIB_DIR="$SCRIPT_DIR/lib"
COLORS_FILE="$COLORS_DIR/colors.json"
WALLPAPER=""
ENGINE="wallust"

# =====================
# PARSEO DE ARGUMENTOS
# =====================

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--engine)
            ENGINE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [-e engine] <wallpaper_path>"
            echo "Engines: wallust (default), wal"
            echo "Ejemplo: $0 ~/Pictures/Wallpapers/samurai.png"
            echo "         $0 -e wal ~/Pictures/Wallpapers/samurai.png"
            exit 0
            ;;
        *)
            WALLPAPER="$1"
            shift
            ;;
    esac
done

# =====================
# VALIDACIONES
# =====================

# Verificar engine válido
case "$ENGINE" in
    wallust|wal)
        ;;
    *)
        echo "Error: Engine inválido: $ENGINE"
        echo "Engines válidos: wallust, wal"
        exit 1
        ;;
esac

# Verificar que se pasó el wallpaper
if [ -z "$WALLPAPER" ]; then
    echo "Usage: $0 [-e engine] <wallpaper_path>"
    echo "Engines: wallust (default), wal"
    exit 1
fi

# Expand ~
WALLPAPER="${WALLPAPER/#\~/$HOME}"

# Verificar que el wallpaper existe
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper no encontrado: $WALLPAPER"
    exit 1
fi

# Verificar que es una imagen válida
case "${WALLPAPER,,}" in
    *.jpg|*.jpeg|*.png|*.webp|*.gif)
        ;;
    *)
        echo "Error: Archivo no es una imagen válida: $WALLPAPER"
        exit 1
        ;;
esac

# =====================
# GENERACIÓN
# =====================

echo "Generando colores desde: $WALLPAPER (engine: $ENGINE)"

case "$ENGINE" in
    wallust)
        # Limpiar cache anterior
        rm -rf "$HOME/.cache/wallust"/* 2>/dev/null || true
        
        # Ejecutar wallust con -s para no escribir secuencias al terminal
        if ! wallust run -s "$WALLPAPER" >/dev/null 2>&1; then
            echo "Error: wallust falló al procesar la imagen"
            exit 1
        fi
        
        # Encontrar archivo de cache
        CACHE_DIR="$HOME/.cache/wallust"
        CACHE_SUBDIR=$(find "$CACHE_DIR" -maxdepth 1 -type d ! -name "wallust" | head -1)
        
        if [ -z "$CACHE_SUBDIR" ]; then
            echo "Error: No se encontró el directorio de cache"
            exit 1
        fi
        
        SCHEME_FILE=$(find "$CACHE_SUBDIR" -maxdepth 1 -name "*Dark" -o -name "*Light" 2>/dev/null | head -1)
        
        if [ -z "$SCHEME_FILE" ] || [ ! -f "$SCHEME_FILE" ]; then
            echo "Error: No se encontró el archivo de colorscheme"
            exit 1
        fi
        
        # Extraer colores
        BG=$(jq -r '.background' "$SCHEME_FILE")
        FG=$(jq -r '.foreground' "$SCHEME_FILE")
        CURSOR=$(jq -r '.cursor // .foreground' "$SCHEME_FILE")
        
        COLORS_ARR=$(jq -c '[
            .color0, .color1, .color2, .color3, .color4, .color5, .color6, .color7,
            .color8, .color9, .color10, .color11, .color12, .color13, .color14, .color15
        ]' "$SCHEME_FILE")
        ;;
        
    wal)
        # Ejecutar wal
        if ! wal -i "$WALLPAPER" -n -q 2>&1; then
            echo "Error: wal falló al procesar la imagen"
            exit 1
        fi
        
        CACHE_FILE="$HOME/.cache/wal/colors.json"
        
        if [ ! -f "$CACHE_FILE" ]; then
            echo "Error: No se encontró el archivo de colores en cache"
            exit 1
        fi
        
        # Copiar directamente (wal ya genera en formato correcto)
        cp "$CACHE_FILE" "$COLORS_FILE"
        
        # Verificar y salir
        if [ -f "$COLORS_FILE" ] && jq -e '.colors' "$COLORS_FILE" > /dev/null 2>&1; then
            echo "Colores guardados en: $COLORS_FILE"
            echo "Background: $(jq -r '.special.background' "$COLORS_FILE")"
            echo "Foreground: $(jq -r '.special.foreground' "$COLORS_FILE")"
            exit 0
        else
            echo "Error: Falló la creación de colors.json"
            exit 1
        fi
        ;;
esac

# =====================
# CREAR colors.json
# =====================

# Crear en formato pywal/wal (compatible)
jq -n \
    --argjson colors "$COLORS_ARR" \
    --arg bg "$BG" \
    --arg fg "$FG" \
    --arg cursor "$CURSOR" \
    '{
        wallpaper: "",
        alpha: "100",
        special: {
            background: $bg,
            foreground: $fg,
            cursor: $cursor
        },
        colors: {
            color0: $colors[0],
            color1: $colors[1],
            color2: $colors[2],
            color3: $colors[3],
            color4: $colors[4],
            color5: $colors[5],
            color6: $colors[6],
            color7: $colors[7],
            color8: $colors[8],
            color9: $colors[9],
            color10: $colors[10],
            color11: $colors[11],
            color12: $colors[12],
            color13: $colors[13],
            color14: $colors[14],
            color15: $colors[15]
        }
    }' > "$COLORS_FILE"

# Validar
if [ -f "$COLORS_FILE" ] && jq -e '.colors' "$COLORS_FILE" > /dev/null 2>&1; then
    echo "Colores guardados en: $COLORS_FILE"
    echo "Background: $(jq -r '.special.background' "$COLORS_FILE")"
    echo "Foreground: $(jq -r '.special.foreground' "$COLORS_FILE")"

    # Verificar y ajustar accesibilidad WCAG
    source "$LIB_DIR/accessibility.sh"
    validate_and_adjust_colors

    exit 0
else
    echo "Error: Falló la creación de colors.json"
    exit 1
fi
