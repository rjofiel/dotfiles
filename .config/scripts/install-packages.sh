#!/bin/bash
#
# install-packages.sh - Instala los paquetes necesarios para los dotfiles
# Uso: ./install-packages.sh [--aur]
#
# Opciones:
#   --aur    Instalar también paquetes de AUR (paru)
#   --dry    Simular instalación sin instalar nada
#

set -euo pipefail

INSTALL_AUR=false
DRY_RUN=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --aur) INSTALL_AUR=true; shift ;;
        --dry) DRY_RUN=true; shift ;;
        -h|--help)
            echo "Usage: $0 [--aur] [--dry]"
            echo "  --aur  Instalar paquetes de AUR (paru)"
            echo "  --dry  Simular instalación sin instalar"
            exit 0
            ;;
        *) shift ;;
    esac
done

# Función para ejecutar comandos
run() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY RUN] $@"
    else
        echo "[RUN] $@"
        eval "$@"
    fi
}

# =====================================================
# Paquetes de Pacman (excluyendo base y linux)
# =====================================================
PACMAN_PACKAGES=(
    # Core / Shell
    "zsh"
    "zsh-completions"
    "bat"
    "fastfetch"
    "fzf"
    "jq"
    
    # Window Manager & UI
    "qtile"
    "alacritty"
    "rofi"
    "picom"
    "dunst"
    "feh"
    "autorandr"
    
    # System / Hardware
    "cbatticon"
    "blueberry"
    "brightnessctl"
    "betterlockscreen"
    "xrandr"
    
    # Fonts
    "ttf-nerd-fonts-symbols"
    "ttf-nerd-fonts-symbols-mono"
    
    # Utils
    "xdotool"
    "xautolock"
    "nm-applet"
    "network-manager-applet"
    "volumeicon"
    "nitrogen"
    
    # Development
    "git"
    "curl"
    "wget"
    "neovim"
    "python"
    "python-pip"
    
    # Extras
    "redshift"
    "playerctl"
    "maim"
    "scrot"
)

# =====================================================
# Paquetes de AUR (paru)
# =====================================================
AUR_PACKAGES=(
    "antigravity-bin"
    "anydesk-bin"
    "archlinux-tweak-tool-bin"
    "brave-bin"
    "dropbox"
    "visual-studio-code-bin"
    # Agregar más paquetes AUR según necesidad
)

echo "=========================================="
echo "Instalación de paquetes para dotfiles"
echo "=========================================="

if [ "$DRY_RUN" = true ]; then
    echo "⚠️  MODO SIMULACIÓN - No se instalará nada"
fi

# Verificar si es root
if [ "$EUID" -eq 0 ] && [ "$DRY_RUN" = false ]; then
    echo "⚠️  No ejecutar como root. Usar sin sudo."
    exit 1
fi

# =====================================================
# Instalar paquetes de Pacman
# =====================================================
echo ""
echo "📦 Paquetes Pacman a instalar (${#PACMAN_PACKAGES[@]}):"
for pkg in "${PACMAN_PACKAGES[@]}"; do
    echo "  - $pkg"
done

if [ "$DRY_RUN" = false ]; then
    echo ""
    read -p "¿Instalar paquetes de Pacman? [s/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        run "sudo pacman -S --needed ${PACMAN_PACKAGES[*]}"
    fi
fi

# =====================================================
# Instalar paru si se pide AUR
# =====================================================
if [ "$INSTALL_AUR" = true ]; then
    # Verificar si paru está instalado
    if ! command -v paru &> /dev/null; then
        echo ""
        echo "📦 Instalando paru (AUR helper)..."
        if [ "$DRY_RUN" = false ]; then
            run "sudo pacman -S --needed git base-devel"
            cd /tmp
            run "git clone https://aur.archlinux.org/paru.git"
            cd paru
            run "makepkg -si"
            cd -
        else
            echo "[DRY RUN] git clone https://aur.archlinux.org/paru.git"
            echo "[DRY RUN] cd paru && makepkg -si"
        fi
    fi

    echo ""
    echo "📦 Paquetes AUR a instalar (${#AUR_PACKAGES[@]}):"
    for pkg in "${AUR_PACKAGES[@]}"; do
        echo "  - $pkg"
    done

    if [ "$DRY_RUN" = false ]; then
        echo ""
        read -p "¿Instalar paquetes de AUR? [s/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            run "paru -S --needed ${AUR_PACKAGES[*]}"
        fi
    fi
fi

echo ""
echo "✅ Instalación completada"
if [ "$DRY_RUN" = true ]; then
    echo "   (MODO SIMULACIÓN - Sin cambios reales)"
fi
