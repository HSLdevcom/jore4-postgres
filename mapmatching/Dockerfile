# Builder docker image.
FROM pgrouting/pgrouting:13-3.1-3.2.0

# install curl
RUN apt-get update && \
  apt-get install curl -y

# download script for reading docker secrets
RUN curl -o /tmp/read-secrets.sh "https://raw.githubusercontent.com/HSLdevcom/jore4-tools/main/docker/read-secrets.sh"

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]

HEALTHCHECK --interval=30s --timeout=5s \
  # have to source the secrets here as well, otherwise the POSTGRES_USER and/or POSTGRES_DB variables might not exist
  CMD source /tmp/read-secrets.sh && pg_isready -h localhost -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"
