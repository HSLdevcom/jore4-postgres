#!/bin/bash

set -Eeuo pipefail

# read the secrets to environment variables
source /jore4/scripts/read-secrets.sh

# copy the migrations scripts to the docker-entrypoint-initdb.d folder so that the postgres entrypoint
# executes them (together with the other migrations that might have been mapped as a volume)
mkdir -p /docker-entrypoint-initdb.d
cp /jore4/migrations/* /docker-entrypoint-initdb.d/

# replace placeholders with secrets within the all migration SQL scripts
SECRET_STORE_BASE_PATH="${SECRET_STORE_BASE_PATH:-/run/secrets}"
REPLACE_PLACEHOLDERS_SCRIPT='/jore4/scripts/replace-placeholders-in-sql-schema-migrations.sh'
MIGRATIONS_DIR="/docker-entrypoint-initdb.d/"
"${REPLACE_PLACEHOLDERS_SCRIPT}" "${SECRET_STORE_BASE_PATH}" "${MIGRATIONS_DIR}"

# call the original entrypoint to continue execution
echo 'Start postgres'
exec /usr/local/bin/docker-entrypoint.sh "$@"
