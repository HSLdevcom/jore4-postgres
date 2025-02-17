# As of 2025-02, in Azure PostgreSQL Flexible Server v15, the most recent
# available version of the PostGIS extension is 3.3.1.
FROM postgis/postgis:15-3.3

# fix collations to use fi_FI
RUN localedef -i fi_FI -c -f UTF-8 -A /usr/share/locale/locale.alias fi_FI.UTF-8
ENV LANG fi_FI.utf8

# download script for reading docker secrets
ADD https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh /jore4/scripts/read-secrets.sh

COPY migrations/ /jore4/migrations/
COPY replace-placeholders-in-sql-schema-migrations.sh /jore4/scripts/replace-placeholders-in-sql-schema-migrations.sh

COPY docker-entrypoint.sh /jore4/scripts/

ENTRYPOINT ["/jore4/scripts/docker-entrypoint.sh"]
CMD ["postgres"]

# have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /jore4/scripts/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
