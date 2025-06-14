#!/bin/bash
LOG="monitor_cpu_mem.log"
while true; do
    echo "$(date) - CPU: $(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')% | Memoria: $(free -m | awk 'NR==2{printf "%s/%sMB", $3,$2 }')" >>$LOG
    sleep 5
done
