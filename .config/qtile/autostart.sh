#!/bin/sh
#
# autostart.sh - Qtile autostart script
#
# Este script se ejecuta al iniciar Qtile.
# Restaura el último wallpaper y aplica theming, o usa un wallpaper por defecto.
#

# =====================
# Helper: verificar si un proceso ya está corriendo
# =====================
is_running() {
    pgrep -x "$1" > /dev/null 2>&1
}

# =====================
# Limpiar instancias previas (asegurar solo una)
# =====================

# Limpiar cbatticon duplicados
if pgrep -f "cbatticon" > /dev/null 2>&1; then
    pkill -f "cbatticon" 2>/dev/null
fi

# Limpiar picom duplicados
if pgrep -f "picom" > /dev/null 2>&1; then
    pkill -f "picom" 2>/dev/null
fi

# Limpiar blueberry-tray duplicados
if pgrep -f "blueberry-tray" > /dev/null 2>&1; then
    pkill -f "blueberry-tray" 2>/dev/null
fi

# =====================
# systray / hardware
# =====================

# Icono de batería en systray
cbatticon -u 5 &

# Compositor
picom --config ~/.config/picom/picom.conf &

# Bluetooth
blueberry-tray &

# Policy kit
/usr/lib/policykit-1-pantheon/io.elementary.desktop.agent-polkit &

# =====================
# Wallpaper y Theming
# =====================

# Log para debug
LOGFILE="$HOME/.local/share/qtile/autostart.log"

# Intentar restaurar el último wallpaper
LAST_WALLPAPER=$(cat /tmp/wallpaper-cycle.txt.current 2>/dev/null)

echo "[autostart] Started at $(date)" >> "$LOGFILE"
echo "[autostart] LAST_WALLPAPER=$LAST_WALLPAPER" >> "$LOGFILE"

if [ -n "$LAST_WALLPAPER" ] && [ -f "$LAST_WALLPAPER" ]; then
    # Restaurar wallpaper guardado
    feh --bg-scale "$LAST_WALLPAPER"
    echo "[autostart] Applied wallpaper: $LAST_WALLPAPER" >> "$LOGFILE"

    # Regenerar theming desde el wallpaper
    sh ~/.config/.colors/scripts/generate.sh "$LAST_WALLPAPER" 2>/dev/null
    sh ~/.config/.colors/scripts/apply-alacritty.sh 2>/dev/null
    sh ~/.config/.colors/scripts/apply-rofi.sh 2>/dev/null
    sh ~/.config/.colors/scripts/apply-dunst.sh 2>/dev/null

    echo "[autostart] Theming applied" >> "$LOGFILE"

    # Qtile: no se toca aquí - requiere recargar config manualmente
else
    # Fallback: usar primer wallpaper disponible
    DEFAULT_WALLPAPER=$(find $HOME/Pictures/Wallpapers -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" \) | head -1)

    echo "[autostart] No cache, using default: $DEFAULT_WALLPAPER" >> "$LOGFILE"

    if [ -n "$DEFAULT_WALLPAPER" ]; then
        feh --bg-scale "$DEFAULT_WALLPAPER"

        # También aplicar theming al fallback
        sh ~/.config/.colors/scripts/generate.sh "$DEFAULT_WALLPAPER" 2>/dev/null
        sh ~/.config/.colors/scripts/apply-alacritty.sh 2>/dev/null
        sh ~/.config/.colors/scripts/apply-rofi.sh 2>/dev/null
        sh ~/.config/.colors/scripts/apply-dunst.sh 2>/dev/null
    fi
fi

echo "[autostart] Finished at $(date)" >> "$LOGFILE"
