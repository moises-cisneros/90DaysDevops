#!/bin/bash
ORIGEN="$1"
DESTINO="$2"
if [ -z "$ORIGEN" ] || [ -z "$DESTINO" ]; then
    echo "Uso: $0 <directorio_origen> <directorio_destino>"
    exit 1
fi
NOMBRE="backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$DESTINO/$NOMBRE" "$ORIGEN"
echo "Backup realizado en $DESTINO/$NOMBRE"
