## Below an inlined version of the PostGIS Dockerfile. PostGIS does not
## relase ARM64 versions of the image at the moment (they did in the past).
## And thus, we have to build the ARM version our selves.

## Rember to also update the Version tag in .github/workflows/cd.yml
FROM docker.io/postgres:18.6-trixie AS postgis

ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.6.4+dfsg-2.pgdg13+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/* \
      && mkdir -p /docker-entrypoint-initdb.d


# Inlined version of the pgrouting Dockerfile. Needed to add support for the ARM64 version.
FROM postgis AS pgrouting

ENV PGROUTING_VERSION=3.8.0
ENV PGROUTING_SHA256=b8a5f0472934fdf7cda3fb4754d01945378d920cdaddc01f378617ddbb9c447f
ENV LIBBOOST_VERSION=1.83.0

RUN set -ex \
 && apt update \
 && apt install -y \
        libboost-atomic${LIBBOOST_VERSION} \
        libboost-chrono${LIBBOOST_VERSION} \
        libboost-graph${LIBBOOST_VERSION}  \
        libboost-date-time${LIBBOOST_VERSION} \
        libboost-program-options${LIBBOOST_VERSION}  \
        libboost-system${LIBBOOST_VERSION}  \
        libboost-thread${LIBBOOST_VERSION}  \
 && apt install -y \
        build-essential \
        cmake \
        curl \
        libboost-graph-dev \
        libpq-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && curl -Lo pgrouting.tar.gz "https://github.com/pgRouting/pgrouting/archive/v${PGROUTING_VERSION}.tar.gz" \
 && echo "$PGROUTING_SHA256 *pgrouting.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/pgrouting \
 && tar \
        --extract \
        --file pgrouting.tar.gz \
        --directory /usr/src/pgrouting \
        --strip-components 1 \
 && rm pgrouting.tar.gz \
 && cd /usr/src/pgrouting \
 && mkdir build \
 && cd build \
 && cmake .. \
 && make -j $(nproc --all) \
 && make install \
 && cd / \
 && rm -rf /usr/src/pgrouting \
 && apt-mark manual postgresql-18 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*


# Create a baseline PostgreSQL server image with PostGIS and PgRouting extensions installed in.
# Can and should be used as the "random postgresql container neede in place X", that is instead
# of pulling in the normal postgres/postgis/pgrouting images where and whenever, use this instead.
FROM pgrouting AS jore4-postgres

# Change collations to use fi_FI
RUN localedef -i fi_FI -c -f UTF-8 -A /usr/share/locale/locale.alias fi_FI.UTF-8
ENV LANG=fi_FI.utf8

RUN mkdir -p -m 0755 /jore4/migrations /jore4/scripts

# Download script for reading docker secrets
ADD --chmod=755 https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh /jore4/scripts/read-secrets.sh

# Read in secrets to ensure POSTGRES_USER and/or POSTGRES_DB are set
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /jore4/scripts/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
