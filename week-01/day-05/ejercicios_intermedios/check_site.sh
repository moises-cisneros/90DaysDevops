#!/bin/bash
SITE="https://roxs.295devops.com"
if curl -s --head $SITE | grep "200 OK" >/dev/null; then
    echo "El sitio $SITE está accesible."
else
    echo "El sitio $SITE NO está accesible."
fi
