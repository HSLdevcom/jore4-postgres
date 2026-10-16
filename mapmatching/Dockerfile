# The Map Matching service's image
ARG FROM=crjore4prod001.azurecr.io/jore4-postgres
FROM ${FROM} AS jore4-postgres-mapmatching

COPY --chmod=755 entrypoint.sh /jore4/scripts/entrypoint.sh
COPY --chmod=644 migrations/ /docker-entrypoint-initdb.d/
ADD --chmod=644 https://stjore4dev001.blob.core.windows.net/jore4-digiroad/2026-08-04_create_routing_schema_digiroad_r_2026-01_mml_2026-08-04.sql /docker-entrypoint-initdb.d/02-digiroad_r_routing.sql

ENTRYPOINT ["/jore4/scripts/entrypoint.sh"]
CMD ["postgres"]
