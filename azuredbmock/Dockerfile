# Builder docker image.
FROM postgis/postgis:14-3.1

# fix collations to use fi_FI
RUN localedef -i fi_FI -c -f UTF-8 -A /usr/share/locale/locale.alias fi_FI.UTF-8
ENV LANG fi_FI.utf8

# install curl
RUN apt-get update && \
  apt-get install curl -y

# download script for reading docker secrets
RUN curl -o /tmp/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

COPY 00-initialize.sql /migrations/00-initialize.sql
COPY replace-placeholders-in-sql-schema-migrations.sh /scripts/replace-placeholders-in-sql-schema-migrations.sh

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]

# have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=20 \
  CMD bash -c "source /tmp/read-secrets.sh && pg_isready -h localhost -U \${POSTGRES_USER} -d \${POSTGRES_DB}"
