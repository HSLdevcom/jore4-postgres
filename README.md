# jore4-postgres

Custom postgresql docker images

Dockerized Postgresql databases for JORE4

## `jore4-postgres:mapmatching`

Extends the original
[pgrouting/pgrouting](https://hub.docker.com/r/pgrouting/pgrouting/) docker
image with the following behavior:

Ports:

The default TCP port `5432` is used as usual.

Volumes:

The `/docker-entrypoint-initdb.d` volume **should not** be mapped as it would
overwrite the initialization sql scripts used by this image.

Environment variables:

| Environment variable          | Example            | Description                                                                            |
| ----------------------------- | ------------------ | -------------------------------------------------------------------------------------- |
| SECRET_STORE_BASE_PATH        | /mnt/secrets-store | Directory containing the docker secrets                                                |
| DIGIROAD_ROUTING_DUMP_VERSION | 2021-09-28         | The version for digiroad routing dump that should be fetched from Azure `jore4storage` |

All other environment variables are the same as as in `pgrouting/pgrouting`

Note that you may also use secrets as a substitute to environment variables.
E.g. `postgres-user`, `postgres-password` and `postgres-db` secrets are exposed
as `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` environment variables
and can be used to set up the database.
