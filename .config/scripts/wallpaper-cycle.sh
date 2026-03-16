#!/bin/bash
#
# wallpaper-cycle.sh - Cambia wallpaper: random, next, prev
# Uso: ./wallpaper-cycle.sh [random|next|prev] [--theme]
#
# --theme: también genera y aplica colores a las apps (alacritty, rofi, dunst)
#          (qtile se excluye porque requiere reinicio)
#

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
CACHE_FILE="/tmp/wallpaper-cycle.txt"
COLORS_DIR="$HOME/.config/.colors"
THEME_SCRIPT="$COLORS_DIR/scripts"

# Flags para theming
APPLY_THEME=false
APPLY_ALACRITTY=true
APPLY_ROFI=true  # SDD de rofi completado
APPLY_QTILE=true  # habilitado, usar --with-qtile para activar (requiere restart)
APPLY_DUNST=true  # script ya existe y funciona

# Obtener lista de wallpapers
get_wallpapers() {
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) 2>/dev/null | sort
}

# Guardar estado actual
save_state() {
    echo "$current_index" > "$CACHE_FILE.index"
    echo "$current_wallpaper" > "$CACHE_FILE.current"
}

# Aplicar wallpaper
apply_wallpaper() {
    feh --bg-scale "$1" --bg-fill "$1"
}

# Aplicar theming
apply_theme() {
    if [ ! -d "$COLORS_DIR" ]; then
        echo "Theming: directorio no encontrado, saltando..."
        return
    fi

    echo "Generando colores..."
    if ! "$THEME_SCRIPT/generate.sh" "$current_wallpaper"; then
        echo "Theming: falló generate.sh"
        return
    fi

    if [ "$APPLY_ALACRITTY" = true ]; then
        echo "Aplicando a Alacritty..."
        "$THEME_SCRIPT/apply-alacritty.sh" || echo "Warning: apply-alacritty.sh falló"
    fi

    if [ "$APPLY_ROFI" = true ]; then
        echo "Aplicando a Rofi..."
        "$THEME_SCRIPT/apply-rofi.sh" || echo "Warning: apply-rofi.sh falló"
    fi

    if [ "$APPLY_DUNST" = true ]; then
        echo "Aplicando a Dunst..."
        "$THEME_SCRIPT/apply-dunst.sh" || echo "Warning: apply-dunst.sh falló"
    fi

    if [ "$APPLY_QTILE" = true ]; then
        echo "Aplicando a Qtile..."
        "$THEME_SCRIPT/apply-qtile.sh" || echo "Warning: apply-qtile.sh falló"
        echo "⚠️  Qtile actualizado. Ejecutá 'mod+ctrl+r' para recargar"
    fi

    echo "Theming aplicado!"
}

# Notificación cuando theming fue exitoso (solo para uso on-demand)
notify_theme() {
    if ! command -v dunstify &> /dev/null; then
        return
    fi

    wallpaper_name=$(basename "$current_wallpaper")
    apps=()

    [ "$APPLY_ALACRITTY" = true ] && apps+=("Alacritty")
    [ "$APPLY_ROFI" = true ] && apps+=("Rofi")
    [ "$APPLY_DUNST" = true ] && apps+=("Dunst")

    apps_str="${apps[*]}"

    if [ "$APPLY_QTILE" = true ]; then
        dunstify -u low -t 5000 "🎨 Theming + Qtile" "$wallpaper_name\n$apps_str\n⚠️ Recargá Qtile (mod+ctrl+r)"
    else
        dunstify -u low -t 3000 "🎨 Theming Applied" "$wallpaper_name\n$apps_str"
    fi
}

# Restart dunst si está corriendo
restart_dunst() {
    if ! command -v dunst &> /dev/null; then
        echo "Dunst no está instalado"
        return
    fi

    # Verificar si dunst está corriendo
    if pgrep -x "dunst" > /dev/null 2>&1; then
        echo "Reiniciando Dunst..."
        killall dunst 2>/dev/null || true
        sleep 0.3
    fi

    # Arrancar dunst en background
    dunst &
    sleep 0.5
    echo "Dunst iniciado"
}

# =====================
# PARSEO DE ARGUMENTOS
# =====================

# Si no hay argumento, usar random
action="${1:-random}"
shift || true

while [[ $# -gt 0 ]]; do
    case $1 in
        --theme) APPLY_THEME=true; shift ;;
        --with-qtile) APPLY_THEME=true; APPLY_QTILE=true; shift ;;
        *) shift ;;
    esac
done

# =====================
# LÓGICA
# =====================

wallpapers=($(get_wallpapers))
total=${#wallpapers[@]}

[ $total -eq 0 ] && echo "No hay wallpapers" && exit 1

# Cargar índice actual
if [ -f "$CACHE_FILE.index" ]; then
    current_index=$(cat "$CACHE_FILE.index")
else
    current_index=-1
fi

case "$action" in
    random)
        # Random
        current_index=$((RANDOM % total))
        ;;
    next)
        # Siguiente (loop)
        current_index=$(((current_index + 1) % total))
        ;;
    prev)
        # Anterior (loop)
        current_index=$(((current_index - 1 + total) % total))
        ;;
    *)
        echo "Uso: $0 [random|next|prev]"
        exit 1
        ;;
esac

# Aplicar
current_wallpaper="${wallpapers[$current_index]}"
apply_wallpaper "$current_wallpaper"

# Guardar estado
save_state

echo "Wallpaper $((current_index + 1))/$total: $(basename "$current_wallpaper")"

# Aplicar theming si se pidió
if [ "$APPLY_THEME" = true ]; then
    apply_theme
    # Restart dunst solo si se aplicaron colores a dunst
    if [ "$APPLY_DUNST" = true ]; then
        restart_dunst
    fi
    notify_theme
fi
