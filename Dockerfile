FROM keeper/commander:latest

# Set environment variables
ENV APP_NAME="keeper-commander-kdbx-exporter"
ARG KEEPER_COMMANDER_KDBX_EXPORTER_REPOSITORY="https://github.com/all-it/keeper-commander-kdbx-exporter.git"

# Metadata
LABEL description="Keeper Commander KDBX Exporter for"
LABEL org.opencontainers.image.description="Keepeper Commander KDBX exporter"
LABEL org.opencontainers.image.title="${APP_NAME}"
LABEL org.opencontainers.image.version="latest"
LABEL org.opencontainers.image.repository="${KEEPER_COMMANDER_KDBX_EXPORTER_REPOSITORY}"

# Change to root user to install dependencies
USER 0

# Create application directory
RUN mkdir -p /mnt/keeper-commander-kdbx-exporter/export
RUN mkdir -p /mnt/keeper-commander-kdbx-exporter/secret

# Create a volume for the exporter to store the export-file
VOLUME "/mnt/keeper-commander-kdbx-exporter/export"

# Download JMX exporter jar and configuration file
RUN pip install pykeepass
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

COPY keepass_exporter.sh keepass_exporter.sh
RUN chmod +x keepass_exporter.sh

# Use a non-root user
USER 1000

ENTRYPOINT [""]

CMD ["./keepass_exporter.sh"]
