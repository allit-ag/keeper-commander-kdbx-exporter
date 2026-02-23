#!/bin/bash
set -e

NOW=$(date +%Y-%m-%d-%H-%M-%S)

user_mail=$(jq -r '.user' /mnt/keeper-commander-kdbx-exporter/secret/secret.json)
password_encryption_key=$(jq -r '.keepass_encryption_key' /mnt/keeper-commander-kdbx-exporter/secret/keepass_encryption_key.json)

echo "Starting Keeper backup at $NOW"

# Export vault
keeper export "$EXPORT_DIR/${NOW}_keeper_backup" \
    --format keepass \
    --keepass-file-password="$password_encryption_key" \
    --server EU \
    --user "$user_mail" \
    --config=/mnt/keeper-commander-kdbx-exporter/secret/secret.json \
    --force

# Export membership
keeper download-membership "$EXPORT_DIR/${NOW}_membership_backup.json" \
    --server EU \
    --user "$user_mail" \
    --config=/mnt/keeper-commander-kdbx-exporter/secret/secret.json \
    --source=keeper

echo "Backup complete. Applying retention policy: $BACKUP_RETENTION_DAYS days delete older files (modified timestamp)."

# Delete files older than retention period (file timestamp is based on last modification time)
find "$EXPORT_DIR" -type f \
    \( -name "*_keeper_backup*" -o -name "*_membership_backup.json" \) \
    -mtime +"$BACKUP_RETENTION_DAYS" \
    -exec rm -v {} \;

echo "Retention cleanup completed"
