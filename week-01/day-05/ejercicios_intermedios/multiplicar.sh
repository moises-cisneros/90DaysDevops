#!/bin/bash
if [ $# -ne 2 ]; then
    echo "Uso: $0 num1 num2"
    exit 1
fi
RESULTADO=$(($1 * $2))
echo "El resultado de $1 x $2 es $RESULTADO"
