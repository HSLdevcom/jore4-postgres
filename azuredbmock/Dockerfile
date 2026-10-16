# The primary Database image
ARG FROM=crjore4prod001.azurecr.io/jore4-postgres
FROM ${FROM} AS jore4-postgres-azuredbmock

COPY --chmod=644 migrations/* /jore4/migrations/
COPY --chmod=755 replace-placeholders-in-sql-schema-migrations.sh /jore4/scripts/replace-placeholders-in-sql-schema-migrations.sh
COPY --chmod=755 entrypoint.sh /jore4/scripts/

ENTRYPOINT ["/jore4/scripts/entrypoint.sh"]
CMD ["postgres"]
