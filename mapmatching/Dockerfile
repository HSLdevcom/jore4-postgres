# Builder docker image.
FROM pgrouting/pgrouting:13-3.1-3.2.0

RUN apt-get update && \
  apt-get install curl -y 

COPY entrypoint.sh /usr/local/bin/

ENTRYPOINT ["entrypoint.sh"]
CMD ["postgres"]

HEALTHCHECK --interval=30s --timeout=5s \
  CMD pg_isready -h localhost -U "${POSTGRES_USER}" -d "${POSTGRES_DB}"