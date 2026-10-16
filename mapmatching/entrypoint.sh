#!/bin/bash

set -Eeuo pipefail

# Read the secrets to environment variables.
source /jore4/scripts/read-secrets.sh

# Include the routing schema in search path.
cat <<EOT > /docker-entrypoint-initdb.d/03-post-initialize.sql
ALTER DATABASE ${POSTGRES_DB} SET search_path = routing, public;
EOT

# Call the original entrypoint to continue startup.
echo 'Start postgres'
exec /usr/local/bin/docker-entrypoint.sh "$@"
