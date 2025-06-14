#!/bin/bash
TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")
LOG="salud_sistema.log"
ALERTAS="alertas_cpu.log"
CPU_ALTA=0
segundos=60
fin=$((SECONDS + segundos))
echo -e "Hora\t\t\tMemoria\t\tDisco (root)\tCPU" | tee -a $LOG
while [ $SECONDS -lt $fin ]; do
    MEMORIA=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 }')
    DISCO=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
    echo -e "$TIEMPO\t$MEMORIA$DISCO$CPU" | tee -a $LOG
    if [ $CPU -gt 85 ]; then
        ((CPU_ALTA++))
        echo "$TIEMPO - CPU alta: $CPU%" >>$ALERTAS
        if [ $CPU_ALTA -ge 3 ]; then
            echo "CPU superó 85% tres veces seguidas. Cortando monitoreo." | tee -a $ALERTAS
            break
        fi
    else
        CPU_ALTA=0
    fi
    sleep 3
done
