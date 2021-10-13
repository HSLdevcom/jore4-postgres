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

The `/docker-entrypoint-initdb.d` volume may be used to execute additional
migration scripts on top of what are used by this image. Don't be surprised
however that the built-in migrations used by this image will appear in the
mapped directory on your host machine as the image internally also uses the
`docker-entrypoint-initdb.d` directory for executing its own migrations.

Environment variables:

| Environment variable          | Example            | Description                                                                            |
| ----------------------------- | ------------------ | -------------------------------------------------------------------------------------- |
| SECRET_STORE_BASE_PATH        | /mnt/secrets-store | Directory containing the docker secrets                                                |
| DIGIROAD_ROUTING_DUMP_VERSION | 2021-09-28         | The version for digiroad routing dump that should be fetched from Azure `jore4storage` |

All other environment variables are the same as as in `pgrouting/pgrouting`'s
base image, [postgres](https://registry.hub.docker.com/_/postgres/)

Note that you may also use secrets as a substitute to environment variables.
E.g. `postgres-user`, `postgres-password` and `postgres-db` secrets are exposed
as `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` environment variables
and can be used to set up the database.

## `jore4-postgres:azuredbmock`

Extends the original
[postgis/postgis](https://hub.docker.com/r/postgis/postgis/) docker image.

The purpose of this image is to provide a dockerised postgresql instance with a
similar experience of what the initial Azure database instance is like right
after being
[provisioned and configured by ansible](https://github.com/HSLdevcom/jore4-deploy#setting-up-database-users).
E.g. we are creating db users.

This image is not responsible for setting up the jore4 database schema, that is
done by the [jore4-hasura image](https://github.com/HSLdevcom/jore4-hasura)

Ports:

The default TCP port `5432` is used as usual.

Volumes:

The `/docker-entrypoint-initdb.d` volume may be used to execute additional
migration scripts on top of what are used by this image. Don't be surprised
however that the built-in migrations used by this image will appear in the
mapped directory on your host machine as the image internally also uses the
`docker-entrypoint-initdb.d` directory for executing its own migrations.

Environment variables:

| Environment variable   | Example            | Description                             |
| ---------------------- | ------------------ | --------------------------------------- |
| SECRET_STORE_BASE_PATH | /mnt/secrets-store | Directory containing the docker secrets |

Secrets:

| Secrets                   | Example         | Description                                                       |
| ------------------------- | --------------- | ----------------------------------------------------------------- |
| db-auth-username          | dbauth          | Name of the database user for the authentication microservice     |
| db-auth-password          | \*\*\*          | Password of the database user for the authentication microservice |
| db-jore3importer-username | dbjore3importer | Name of the database user for the jore3 importer microservice     |
| db-jore3importer-password | \*\*\*          | Name of the database user for the jore3 importer microservice     |
| db-hasura-username        | dbhasura        | Name of the database user for the hasura microservice             |
| db-hasura-password        | \*\*\*          | Password of the database user for the hasura microservice         |
| db-hasura-name            | jore4db         | Name of the database used by the hasura microservice              |

All other environment variables are the same as as in `postgis/postgis`'s base
image, [postgres](https://registry.hub.docker.com/_/postgres/)

Note that you may also use secrets as a substitute to environment variables.
E.g. `postgres-user`, `postgres-password` and `postgres-db` secrets are exposed
as `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` environment variables
and can be used to set up the database.
