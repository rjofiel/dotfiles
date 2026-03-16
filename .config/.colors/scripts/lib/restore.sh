#!/bin/bash
#
# restore.sh - Restaura archivo desde backup .bak
# Usage: restore.sh <file_path>
# Exit: 0 si restore exitoso, 1 si no hay backup
#

set -euo pipefail

FILE="$1"
BAK="${FILE}.bak"

if [ -f "$BAK" ]; then
    mv "$BAK" "$FILE"
    echo "Restaurado desde: $BAK"
    exit 0
else
    echo "Error: No existe backup: $BAK"
    exit 1
fi
