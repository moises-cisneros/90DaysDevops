#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Uso: $0 <usuario>"
    exit 1
fi
USUARIO=$1
groupadd -f devops
if id "$USUARIO" &>/dev/null; then
    echo "El usuario ya existe."
else
    useradd -m -g devops "$USUARIO"
    echo "Usuario $USUARIO creado y agregado al grupo devops."
fi
