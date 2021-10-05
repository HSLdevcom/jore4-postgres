#!/bin/bash

set -Eeuo pipefail

# read the secrets to environment variables
source /tmp/read-secrets.sh

# as the original digiroad dump does not initialize a few things, create them manually
cat <<EOT >> /docker-entrypoint-initdb.d/01-initialize.sql
CREATE SCHEMA IF NOT EXISTS routing;
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
EOT

# download digiroad routing dump at startup
echo 'Downloading digiroad routing dump'
curl -o /docker-entrypoint-initdb.d/02-digiroad_r_routing.sql \
    https://jore4storage.blob.core.windows.net/jore4-digiroad/digiroad_r_routing_${DIGIROAD_ROUTING_DUMP_VERSION}.sql

# call the original entrypoint to continue execution
echo 'Start postgres'
exec /usr/local/bin/docker-entrypoint.sh "$@"
