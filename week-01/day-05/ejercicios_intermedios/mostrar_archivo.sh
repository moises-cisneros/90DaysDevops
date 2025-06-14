#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Uso: $0 <archivo>"
    exit 1
fi
if [ -f "$1" ]; then
    cat "$1"
else
    echo "El archivo $1 no existe."
fi
