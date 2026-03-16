#!/bin/bash
#
# install-dotfiles.sh - Instala dotfiles desde el repositorio
# Uso: ./install-dotfiles.sh [--force]
#

set -euo pipefail

FORCE=false

# Parsear argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        --force) FORCE=true; shift ;;
        *) shift ;;
    esac
done

# Verificar que es un repo bare
if [ ! -d "$HOME/.dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone --bare git@github.com:Fazeludox/dotfiles.git "$HOME/.dotfiles"
fi

# Función helper para git
config() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

# Verificar backup existente
BACKUP_DIR="$HOME/.config-backup"
if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
    if [ "$FORCE" = false ]; then
        echo "⚠️  Ya existe un backup en $BACKUP_DIR"
        echo "   Ejecutá con --force para sobrescribir, o manualmenteborrar el directorio"
        exit 1
    else
        echo "⚠️  Backup existente será preservado en $(date +%Y%m%d_%H%M%S)"
        mv "$BACKUP_DIR" "${BACKUP_DIR}_$(date +%Y%m%d_%H%M%S)"
    fi
fi

# Crear directorio de backup
mkdir -p "$BACKUP_DIR"

# Intentar checkout
echo "Checking out dotfiles..."
if config checkout 2>&1; then
    echo "✅ Dotfiles installed successfully"
else
    echo "📦 Backup de archivos existentes..."
    
    # Mover archivos que existen a backup
    config checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | while read -r file; do
        if [ -e "$HOME/$file" ]; then
            echo "   Backing up: $file"
            mv "$HOME/$file" "$BACKUP_DIR/"
        fi
    done
    
    # Reintentar checkout
    echo "Reintentando checkout..."
    config checkout
fi

# Configurar git
config config status.showUntrackedFiles no

echo "✅ Instalación completa"
echo "   Backup en: $BACKUP_DIR"
