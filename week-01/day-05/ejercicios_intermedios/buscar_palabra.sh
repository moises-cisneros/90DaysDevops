#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Uso: $0 archivo palabra"
    exit 1
fi
if grep -q "$2" "$1"; then
    echo "¡Encontrado!"
else
    echo "No encontrado."
fi
