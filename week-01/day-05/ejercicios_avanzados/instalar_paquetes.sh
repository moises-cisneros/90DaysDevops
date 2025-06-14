#!/bin/bash
PAQUETES=(git vim curl)
for pkg in "${PAQUETES[@]}"; do
    if ! dpkg -l | grep -qw $pkg; then
        echo "Instalando $pkg..."
        sudo apt-get install -y $pkg
    else
        echo "$pkg ya está instalado."
    fi
done
