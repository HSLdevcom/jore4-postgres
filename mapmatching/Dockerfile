## Below an inlined version of the PostGIS Dockerfile. PostGIS does not
## relase ARM64 versions of the image at the moment (they did in the past).
## And thus, we have to build the ARM version our selves.

FROM docker.io/postgres:15-bullseye AS postgis

ENV POSTGIS_MAJOR=3
ENV POSTGIS_VERSION=3.5.2+dfsg-1.pgdg110+1

# Switch to Debian Archive for EOL disto version
RUN rm /etc/apt/sources.list
ADD archive.sources.list /etc/apt/sources.list

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           # ca-certificates: for accessing remote raster files;
           #   fix: https://github.com/postgis/docker-postgis/issues/307
           ca-certificates \
           \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d


# Inlined version of the pgrouting Dockerfile. Needed to add support for the ARM64 version.
FROM postgis AS pgrouting

ENV PGROUTING_VERSION=3.8.0
ENV PGROUTING_SHA256=b8a5f0472934fdf7cda3fb4754d01945378d920cdaddc01f378617ddbb9c447f

RUN set -ex \
 && apt update \
 && apt install -y \
        libboost-atomic1.74.0 \
        libboost-chrono1.74.0 \
        libboost-graph1.74.0 \
        libboost-date-time1.74.0 \
        libboost-program-options1.74.0 \
        libboost-system1.74.0 \
        libboost-thread1.74.0 \
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
 && make \
 && make install \
 && cd / \
 && rm -rf /usr/src/pgrouting \
 && apt-mark manual postgresql-15 \
 && apt purge -y --autoremove \
        build-essential \
        cmake \
        libpq-dev \
        libboost-graph-dev \
        postgresql-server-dev-${PG_MAJOR} \
 && rm -rf /var/lib/apt/lists/*


FROM pgrouting

# download script for reading docker secrets
ADD --chmod=755 https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh /tmp/read-secrets.sh

COPY --chmod=755 entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]

# have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /tmp/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
