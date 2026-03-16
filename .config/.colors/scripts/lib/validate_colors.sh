#!/bin/bash
#
# validate_colors.sh - Valida que colors.json tenga estructura correcta
# Funcion como fuente para otros scripts
# Formato: { colors: {color0-color15}, special: {background, foreground, cursor} }
#

validate_colors() {
    local COLORS_FILE="${1:-}"
    
    if [ -z "$COLORS_FILE" ]; then
        echo "Error: No se especificó archivo"
        return 1
    fi
    
    # Expand ~
    COLORS_FILE="${COLORS_FILE/#\~/$HOME}"
    
    if [ ! -f "$COLORS_FILE" ]; then
        echo "Error: colors.json no encontrado: $COLORS_FILE"
        return 1
    fi
    
    # Verificar estructura con jq
    # Formato pywal: .colors.color0, .special.background
    if ! jq -e '.colors' "$COLORS_FILE" > /dev/null 2>&1; then
        echo "Error: colors.json no tiene campo 'colors'"
        return 1
    fi
    
    # Acepta tanto .background como .special.background
    if ! jq -e '.special.background // .background' "$COLORS_FILE" > /dev/null 2>&1; then
        echo "Error: colors.json no tiene campo 'background' o 'special.background'"
        return 1
    fi
    
    if ! jq -e '.special.foreground // .foreground' "$COLORS_FILE" > /dev/null 2>&1; then
        echo "Error: colors.json no tiene campo 'foreground' o 'special.foreground'"
        return 1
    fi
    
    # Verificar que hay 16 colores
    local COLOR_COUNT
    COLOR_COUNT=$(jq '.colors | length' "$COLORS_FILE")
    if [ "$COLOR_COUNT" -ne 16 ]; then
        echo "Error: colors.json debe tener 16 colores, tiene: $COLOR_COUNT"
        return 1
    fi
    
    echo "colors.json válido"
    return 0
}
