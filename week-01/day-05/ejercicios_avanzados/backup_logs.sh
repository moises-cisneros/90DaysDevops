#!/bin/bash
set -e
BACKUP_DIR="$HOME/backups"
mkdir -p "$BACKUP_DIR"
ARCHIVO="log_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$BACKUP_DIR/$ARCHIVO" /var/log
find "$BACKUP_DIR" -type f -mtime +7 -delete
echo "Backup realizado en $BACKUP_DIR/$ARCHIVO"
