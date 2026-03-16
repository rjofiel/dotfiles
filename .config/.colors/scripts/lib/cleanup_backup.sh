#!/bin/bash
#
# cleanup_backup.sh - Limpia backup .bak anterior si el apply fue exitoso
# Usage: cleanup_backup.sh <file_path>
# Exit: 0 siempre
#

set -euo pipefail

FILE="$1"
BAK="${FILE}.bak"

if [ -f "$BAK" ]; then
    rm "$BAK"
    echo "Backup limpiado: $BAK"
else
    echo "No hay backup para limpiar: $FILE"
fi
