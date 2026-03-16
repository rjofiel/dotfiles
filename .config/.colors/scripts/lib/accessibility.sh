#!/bin/bash
#
# accessibility.sh - Biblioteca de validación y ajuste de colores WCAG
# Proporciona funciones para calcular contraste y ajustar colores para accesibilidad
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Usar $HOME para paths absolutos
COLORS_DIR="$HOME/.config/.colors"
COLORS_FILE="$COLORS_DIR/colors.json"

# Colores de fallback (tokyonight dark)
FALLBACK_BG="#1a1b26"
FALLBACK_FG="#a9b1d6"

# Ratio mínimo WCAG AA
MIN_RATIO=4.5

# =====================================================
# Funciones de cálculo WCAG (Python inline)
# =====================================================

# Calcula el ratio de contraste entre dos colores
# Usage: calculate_contrast "#RRGGBB" "#RRGGBB"
# Returns: ratio float
calculate_contrast() {
    local bg="$1"
    local fg="$2"

    python3 - "$bg" "$fg" << 'PYEOF'
import sys
import math

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def relative_luminance(r, g, b):
    def adjust(c):
        c = c / 255.0
        if c <= 0.03928:
            return c / 12.92
        else:
            return ((c + 0.055) / 1.055) ** 2.4
    
    r_adj = adjust(r)
    g_adj = adjust(g)
    b_adj = adjust(b)
    
    return 0.2126 * r_adj + 0.7152 * g_adj + 0.0722 * b_adj

def contrast_ratio(color1, color2):
    rgb1 = hex_to_rgb(color1)
    rgb2 = hex_to_rgb(color2)
    
    l1 = relative_luminance(*rgb1)
    l2 = relative_luminance(*rgb2)
    
    lighter = max(l1, l2)
    darker = min(l1, l2)
    
    return (lighter + 0.05) / (darker + 0.05)

bg = sys.argv[1]
fg = sys.argv[2]

ratio = contrast_ratio(bg, fg)
print(f"{ratio:.2f}")
PYEOF
}

# =====================================================
# Funciones de ajuste de color (Python inline)
# =====================================================

# Ajusta el color hasta alcanzar el contraste mínimo
# Usage: adjust_color_for_contrast bg fg min_ratio
# Returns: nuevo color hex
adjust_color_for_contrast() {
    local bg="$1"
    local fg="$2"
    local min_ratio="${3:-$MIN_RATIO}"

    python3 - "$bg" "$fg" "$min_ratio" << 'PYEOF'
import sys
import math

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(r, g, b):
    return f"#{r:02x}{g:02x}{b:02x}"

def relative_luminance(r, g, b):
    def adjust(c):
        c = c / 255.0
        if c <= 0.03928:
            return c / 12.92
        else:
            return ((c + 0.055) / 1.055) ** 2.4
    
    r_adj = adjust(r)
    g_adj = adjust(g)
    b_adj = adjust(b)
    
    return 0.2126 * r_adj + 0.7152 * g_adj + 0.0722 * b_adj

def contrast_ratio(color1, color2):
    rgb1 = hex_to_rgb(color1)
    rgb2 = hex_to_rgb(color2)
    
    l1 = relative_luminance(*rgb1)
    l2 = relative_luminance(*rgb2)
    
    lighter = max(l1, l2)
    darker = min(l1, l2)
    
    return (lighter + 0.05) / (darker + 0.05)

def rgb_to_hsl(r, g, b):
    r, g, b = r / 255.0, g / 255.0, b / 255.0
    
    max_c = max(r, g, b)
    min_c = min(r, g, b)
    l = (max_c + min_c) / 2.0
    
    if max_c == min_c:
        h = s = 0.0
    else:
        d = max_c - min_c
        s = d / (2.0 - max_c - min_c) if l > 0.5 else d / (max_c + min_c)
        
        if max_c == r:
            h = ((g - b) / d + (6 if g < b else 0)) / 6.0
        elif max_c == g:
            h = ((b - r) / d + 2) / 6.0
        else:
            h = ((r - g) / d + 4) / 6.0
    
    return h * 360, s * 100, l * 100

def hsl_to_rgb(h, s, l):
    h, s, l = h / 360.0, s / 100.0, l / 100.0
    
    if s == 0:
        v = int(round(l * 255))
        return v, v, v
    
    def hue_to_rgb(p, q, t):
        if t < 0: t += 1
        if t > 1: t -= 1
        if t < 1/6: return p + (q - p) * 6 * t
        if t < 1/2: return q
        if t < 2/3: return p + (q - p) * (2/3 - t) * 6
        return p
    
    q = l * (1 + s) if l < 0.5 else l + s - l * s
    p = 2 * l - q
    
    r = int(round(hue_to_rgb(p, q, h + 1/3) * 255))
    g = int(round(hue_to_rgb(p, q, h) * 255))
    b = int(round(hue_to_rgb(p, q, h - 1/3) * 255))
    
    return r, g, b

bg = sys.argv[1]
fg = sys.argv[2]
min_ratio = float(sys.argv[3])

# Calcular luminancia del background
bg_rgb = hex_to_rgb(bg)
bg_lum = relative_luminance(*bg_rgb)

# Convertir fg a HSL
fg_rgb = hex_to_rgb(fg)
h, s, l = rgb_to_hsl(*fg_rgb)

# Determinar dirección de ajuste
# Si bg es oscuro (< 0.5), fg debe ser CLARO para contraste
# Si bg es claro (> 0.5), fg debe ser OSCURO para contraste
if bg_lum < 0.5:
    # Background oscuro: AC LARAR fg
    direction = 1
else:
    # Background claro: oscurecer fg
    direction = -1

original_fg = fg
best_fg = fg
best_ratio = contrast_ratio(bg, fg)

# Iterar hasta 10 veces
for i in range(11):
    current_ratio = contrast_ratio(bg, fg)
    
    if current_ratio >= min_ratio:
        best_fg = fg
        best_ratio = current_ratio
        break
    
    # Ajustar lightness
    l += direction * 5  # 5% por iteración
    l = max(0, min(100, l))
    
    fg_rgb = hsl_to_rgb(h, s, l)
    fg = rgb_to_hex(*fg_rgb)
    
    current_ratio = contrast_ratio(bg, fg)
    if current_ratio > best_ratio:
        best_fg = fg
        best_ratio = current_ratio

if best_ratio < min_ratio:
    print(f"FAILED")
else:
    print(f"{best_fg}")
PYEOF
}

# =====================================================
# Función principal de validación y ajuste
# =====================================================

# Valida y ajusta los colores en colors.json
# Usage: validate_and_adjust_colors
# Returns: 0 si OK, 1 sifallback
validate_and_adjust_colors() {
    if [ ! -f "$COLORS_FILE" ]; then
        echo "accessibility.sh: colors.json no encontrado"
        return 1
    fi

    echo "Verificando contraste WCAG..."

    # Leer colores actuales
    local bg fg
    bg=$(jq -r '.special.background' "$COLORS_FILE")
    fg=$(jq -r '.special.foreground' "$COLORS_FILE")

    if [ -z "$bg" ] || [ -z "$fg" ]; then
        echo "accessibility.sh: No se pudieron leer colores de colors.json"
        return 1
    fi

    # Calcular contraste actual
    local ratio
    ratio=$(calculate_contrast "$bg" "$fg")

    echo "Contraste actual: ${ratio}:1 (mínimo: ${MIN_RATIO}:1)"

    # Verificar si pasa el test
    local needs_adjust=false
    if (( $(echo "$ratio < $MIN_RATIO" | bc -l) )); then
        needs_adjust=true
    fi

    if [ "$needs_adjust" = true ]; then
        echo "Contraste insuficiente. Ajustando foreground..."

        local new_fg
        new_fg=$(adjust_color_for_contrast "$bg" "$fg" "$MIN_RATIO")

        if [ "$new_fg" = "FAILED" ]; then
            echo "No se pudo alcanzar contraste mínimo. Usando fallback..."
            echo "⚠️  Colores fallback: bg=$FALLBACK_BG, fg=$FALLBACK_FG"

            # Aplicar fallback
            jq --arg bg "$FALLBACK_BG" \
               --arg fg "$FALLBACK_FG" \
               '.special.background = $bg | .special.foreground = $fg' \
               "$COLORS_FILE" > "${COLORS_FILE}.tmp" && \
            mv "${COLORS_FILE}.tmp" "$COLORS_FILE"

            return 1
        else
            # Calcular nuevo contraste
            local new_ratio
            new_ratio=$(calculate_contrast "$bg" "$new_fg")

            echo "Ajustando foreground: $fg → $new_fg"
            echo "Nuevo contraste: ${new_ratio}:1"

            # Actualizar colors.json
            jq --arg fg "$new_fg" \
               '.special.foreground = $fg' \
               "$COLORS_FILE" > "${COLORS_FILE}.tmp" && \
            mv "${COLORS_FILE}.tmp" "$COLORS_FILE"

            echo "✓ Contraste ajustado a ${new_ratio}:1"
        fi
    else
        echo "✓ Contraste OK (${ratio}:1 >= ${MIN_RATIO}:1)"
    fi

    return 0
}
