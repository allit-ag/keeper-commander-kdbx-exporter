#!/bin/bash

password_encryption_key=$(jq -r '.user' /mnt/keeper-commander-kdbx-exporter/secret/secret.json)
user_mail=$(jq -r '.keepass_encryption_key' /mnt/keeper-commander-kdbx-exporter/secret/keepass_encryption_key.json)

keeper export /mnt/keeper-commander-kdbx-exporter/export/$(date +%Y-%m-%d-%H-%M-%S)_keeper_backup.kdbx \
    --format keepass \
    --keepass-file-password="$password_encryption_key" \
    --server EU --user "$user_mail" \
    --config=/mnt/keeper-commander-kdbx-exporter/secret/secret.json \
    --force

keeper download-membership /mnt/keeper-commander-kdbx-exporter/export/$(date +%Y-%m-%d-%H-%M-%S)_membership_backup.json \
    --server EU --user "$user_mail" \
    --config=/mnt/keeper-commander-kdbx-exporter/secret/secret.json \
    --source=keeper
