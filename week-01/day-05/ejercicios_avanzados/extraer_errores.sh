#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Uso: $0 <archivo_log>"
    exit 1
fi
grep -i "error" "$1"
