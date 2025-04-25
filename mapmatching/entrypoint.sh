#!/bin/bash

set -Eeuo pipefail

# Read the secrets to environment variables.
source /tmp/read-secrets.sh

# As the database dump does not initialise extensions, create them manually.
cat <<EOT > /docker-entrypoint-initdb.d/01-initialize.sql
CREATE EXTENSION postgis;
CREATE EXTENSION pgrouting;
EOT

# Download the routing/map-matching database dump based on Digiroad data.
echo 'Downloading database dump...'
curl -o /docker-entrypoint-initdb.d/02-digiroad_r_routing.sql \
    ${DIGIROAD_ROUTING_DUMP_URL}

# Include the routing schema in search path.
cat <<EOT > /docker-entrypoint-initdb.d/03-post-initialize.sql
ALTER DATABASE ${POSTGRES_DB} SET search_path = routing, public;
EOT

# Call the original entrypoint to continue startup.
echo 'Start postgres'
exec /usr/local/bin/docker-entrypoint.sh "$@"
