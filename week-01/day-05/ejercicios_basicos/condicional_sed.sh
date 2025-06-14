#!/bin/bash
read -p "¿Tenés sed? (si/no): " RESPUESTA
if [ "$RESPUESTA" == "si" ]; then
    echo "Andá por un cafecito ☕"
else
    echo "Seguimos con DevOps 🚀"
fi
