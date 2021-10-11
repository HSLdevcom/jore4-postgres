#!/bin/bash

set -Eeuo pipefail

# read the secrets to environment variables
source /tmp/read-secrets.sh

# as the original Digiroad dump does not initialize a few things, create them manually
cat <<EOT > /docker-entrypoint-initdb.d/01-initialize.sql
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
EOT

# download Digiroad routing dump at startup
echo 'Downloading digiroad routing dump'
curl -o /docker-entrypoint-initdb.d/02-digiroad_r_routing.sql \
    https://jore4storage.blob.core.windows.net/jore4-digiroad/digiroad_r_routing_${DIGIROAD_ROUTING_DUMP_VERSION}.sql

# include routing schema in search path
cat <<EOT > /docker-entrypoint-initdb.d/03-post-initialize.sql
ALTER DATABASE ${POSTGRES_DB} SET search_path = routing, public;
EOT

# call the original entrypoint to continue execution
echo 'Start postgres'
exec /usr/local/bin/docker-entrypoint.sh "$@"
