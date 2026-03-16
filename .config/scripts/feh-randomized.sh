#!/bin/bash
#
# feh-randomized.sh - Wallpaper randomizer + theming
# Elige un wallpaper aleatorio de ~/Pictures/Wallpapers/ y lo aplica con feh
# Luego genera colores y aplica a las apps configuradas
#
# Dependencias: feh, shuf, find, wallust/wal
#

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
COLORS_DIR="$HOME/.config/.colors"
THEME_SCRIPT="$COLORS_DIR/scripts"

# Flags
APPLY_ALL=true
APPLY_ALACRITTY=true
APPLY_ROFI=false
APPLY_QTILE=false
APPLY_DUNST=false

# =====================
# PARSEO DE ARGUMENTOS
# =====================

while [[ $# -gt 0 ]]; do
    case $1 in
        --alacritty) APPLY_ALACRITTY=true; shift ;;
        --rofi) APPLY_ROFI=true; shift ;;
        --qtile) APPLY_QTILE=true; shift ;;
        --dunst) APPLY_DUNST=true; shift ;;
        --all) APPLY_ALACRITTY=true; APPLY_ROFI=true; APPLY_QTILE=true; APPLY_DUNST=true; shift ;;
        --none) APPLY_ALL=false; shift ;;
        *) shift ;;
    esac
done

# =====================
# VALIDACIONES
# =====================

if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Directorio de wallpapers no encontrado: $WALLPAPER_DIR"
    exit 1
fi

image_count=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | wc -l)

if [ "$image_count" -eq 0 ]; then
    echo "Error: No se encontraron imágenes en $WALLPAPER_DIR"
    exit 1
fi

# =====================
# SELECCIÓN ALEATORIA
# =====================

selected_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) -print0 | shuf -z -n 1 | tr -d "\0")

if [ -z "$selected_wallpaper" ]; then
    echo "Error: No se pudo seleccionar un wallpaper"
    exit 1
fi

# =====================
# APLICAR WALLPAPER
# =====================

echo "Aplicando wallpaper: $selected_wallpaper"
feh --bg-scale "$selected_wallpaper" --bg-fill "$selected_wallpaper"

# =====================
# GENERAR COLORES Y APLICAR
# =====================

if [ "$APPLY_ALL" = false ]; then
    echo "Theming deshabilitado (--none)"
    exit 0
fi

echo "Generando colores..."
if ! "$THEME_SCRIPT/generate.sh" "$selected_wallpaper"; then
    echo "Error: Falló generate.sh"
    exit 1
fi

# Aplicar a cada app
if [ "$APPLY_ALACRITTY" = true ]; then
    echo "Aplicando a Alacritty..."
    "$THEME_SCRIPT/apply-alacritty.sh" || echo "Warning: apply-alacritty.sh falló"
fi

if [ "$APPLY_ROFI" = true ]; then
    echo "Aplicando a Rofi..."
    "$THEME_SCRIPT/apply-rofi.sh" || echo "Warning: apply-rofi.sh falló"
fi

if [ "$APPLY_QTILE" = true ]; then
    echo "Aplicando a Qtile..."
    "$THEME_SCRIPT/apply-qtile.sh" || echo "Warning: apply-qtile.sh falló"
fi

if [ "$APPLY_DUNST" = true ]; then
    echo "Aplicando a Dunst..."
    "$THEME_SCRIPT/apply-dunst.sh" || echo "Warning: apply-dunst.sh falló"
fi

echo "Done!"
