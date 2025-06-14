#!/bin/bash
ADMIN="admin@ejemplo.com"
USO_RAIZ=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home | awk '{print $1}' | sed 's/G//g')
FECHA=$(date '+%Y-%m-%d %H:%M:%S')
LOG="monitor_disco.log"
if [ "$USO_RAIZ" -ge 90 ]; then
    echo "$FECHA - ¡Alerta: Partición / al ${USO_RAIZ}%!" | tee -a $LOG
fi
if (($(echo "$TAMANO_HOME > 2" | bc -l))); then
    echo "$FECHA - ¡Alerta: /home ocupa ${TAMANO_HOME}GB!" | tee -a $LOG
fi
