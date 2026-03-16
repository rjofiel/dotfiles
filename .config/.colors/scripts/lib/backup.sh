#!/bin/bash
#
# backup.sh - Crea backup .bak de un archivo
# Solo mantiene 1 archivo de backup
# Usage: backup.sh <file_path>
# Exit: 0 siempre (no falla si no existe el archivo)
#

set -euo pipefail

FILE="$1"
BAK="${FILE}.bak"

if [ -f "$FILE" ]; then
    # Eliminar backup anterior (solo 1 backup max)
    if [ -f "$BAK" ]; then
        rm "$BAK"
    fi
    cp "$FILE" "$BAK"
    echo "Backup creado: $BAK"
else
    echo "Archivo no existe, no se crea backup: $FILE"
fi
