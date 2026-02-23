# keeper-commander-kdbx-exporter

### Run the container locally and interactive

### Build the Container locally
Build the Contaier in a local environment
`docker build -t keeper-commander-kdbx-exporter:latest . `


#### Interactive Login to debug inside container
Manually run `./keepass_exporter.sh`.
When you try to login and it asks for `Selection`, type `1` to use `TOTP`

```bash
docker run -it \
    --rm \
    -v $(pwd)/secret:/mnt/keeper-commander-kdbx-exporter/secret \
    -v $(pwd)/export:/mnt/keeper-commander-kdbx-exporter/export keeper-commander-kdbx-exporter:latest \
    "/bin/bash"
```


#### Example Backup Command
```bash
keeper export /mnt/keeper-commander-kdbx-exporter/export/backup__$(date +%Y-%m-%d-%H-%M-%S) \
    --format keepass \
    --keepass-file-password='MySecretPassword' \
    --server EU --user `user@mail.com` \
    --config=/mnt/keeper-commander-kdbx-exporter/secret/secret.json \
    --force
```


### Example Config-File generation
Mount the `secret.json` at `/mnt/keeper-commander-kdbx-exporter/secret/secret.json` or start the container with the desired mount path.

> The config can be generated when installing [keeper commander](https://docs.keeper.io/en/keeperpam/commander-cli/commander-installation-setup/installation-on-linux) and logging in with a config file

`keeper shell --config /path/to/secret.json`

### Required Container Configurations
`/mnt/keeper-commander-kdbx-exporter/secret/secret.json`
```json
{
  "server": "keepersecurity.eu",
  "device_token": "example_token",
  "private_key": "example_private_key",
  "user": "example_user@mail.com",
  "clone_code": "clone_code"
}
```

#### KeePass Encryption Key
`/mnt/keeper-commander-kdbx-exporter/secret/keepass_encryption_key.json`
```json
{
  "keepass_encryption_key": "very-secret-encryption-key"
}
```

#### Optional ENV-Variables
| ENV-Variable | Description |
|---|---|
| BACKUP_RETENTION_DAYS | Configures the Retention days of the Backups. Defaults to `365` |
| EXPORT_DIR | Configures the export dir path inside the Container. Defaults to `/mnt/keeper-commander-kdbx-exporter/export` |
