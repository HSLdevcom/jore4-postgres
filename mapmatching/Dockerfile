# builder image
FROM postgis/postgis:15-3.3 AS pgrouting

# PG_MAJOR environment variable is made available by postgis image. It is used
# while building pgRouting extension.

ENV \
 PGROUTING_VERSION=3.5.0 \
 PGROUTING_SHA256=ce3a591d57466d64420923b6ac4df10ad27cac9f5e21f18eed66afe4543dfb48

# build and install pgRouting from source
RUN set -ex \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    libboost-graph1.74.0 \
    libboost-graph1.74-dev \
    libcgal-dev \
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
 && apt-get purge -y --autoremove \
    build-essential \
    cmake \
    curl \
    libboost-graph1.74.0 \
    libboost-graph1.74-dev \
    libcgal-dev \
    postgresql-server-dev-${PG_MAJOR} \
 && apt-get clean -y \
 && rm -rf /var/lib/apt/lists/*

FROM pgrouting

# install curl
RUN set -ex \
 && apt-get update \
 && apt-get install -y curl \
 && rm -rf /var/lib/apt/lists/*

# download script for reading docker secrets
RUN curl -o /tmp/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]

# have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /tmp/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
