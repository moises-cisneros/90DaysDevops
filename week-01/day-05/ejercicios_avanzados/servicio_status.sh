#!/bin/bash
SERVICIOS=(nginx mysql docker)
ADMIN="admin@ejemplo.com"
for SERVICIO in "${SERVICIOS[@]}"; do
    if systemctl is-active --quiet $SERVICIO; then
        echo "$SERVICIO está activo."
    else
        echo "$SERVICIO está caído." | tee -a servicio_status.log
    fi
done
