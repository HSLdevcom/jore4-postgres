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

| Environment variable          | Example    | Description                                                                     |
| ----------------------------- | ---------- | ------------------------------------------------------------------------------- |
| DIGIROAD_ROUTING_DUMP_VERSION | 2021-09-28 | The version for digiroad routing dump that should be fetched from Azure storage |

All other environment variables are the same as as in `pgrouting/pgrouting`
