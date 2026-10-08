## Below an inlined version of the PostGIS Dockerfile. PostGIS does not
## relase ARM64 versions of the image at the moment (they did in the past).
## And thus, we have to build the ARM version our selves.

FROM docker.io/postgres:18-trixie AS postgis

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
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d


FROM postgis

# Change collations to use fi_FI
RUN localedef -i fi_FI -c -f UTF-8 -A /usr/share/locale/locale.alias fi_FI.UTF-8
ENV LANG=fi_FI.utf8

RUN mkdir -p -m 0755 /jore4/migrations /jore4/scripts

# Download script for reading docker secrets
ADD --chmod=755 https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh /jore4/scripts/read-secrets.sh

COPY --chmod=644 migrations/ /jore4/migrations/
COPY --chmod=755 replace-placeholders-in-sql-schema-migrations.sh /jore4/scripts/replace-placeholders-in-sql-schema-migrations.sh

COPY --chmod=755 docker-entrypoint.sh /jore4/scripts/

ENTRYPOINT ["/jore4/scripts/docker-entrypoint.sh"]
CMD ["postgres"]

# have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /jore4/scripts/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
