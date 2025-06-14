#!/bin/bash
find /var/log -type f -mtime +7 -exec rm -f {} \;
echo "Logs mayores a 7 días eliminados."
