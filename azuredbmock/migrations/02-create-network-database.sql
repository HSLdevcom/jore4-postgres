-- Make the JORE4 admin role the owner of the public schema.
ALTER SCHEMA public OWNER TO CURRENT_USER;

-- Create the extensions used, see https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html
-- Create the extensions in the public schema, since we'd need to give additional privileges ("use schema") to any
-- user who wishes to use these in the future. Also, Hasura would require additional setup to be able to use the
-- extensions from another schema.
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

-- Allow Hasura to connect and create new schemas.
GRANT CONNECT, CREATE ON DATABASE xxx_db_hasura_name_xxx TO xxx_db_hasura_username_xxx;

-- Grant required privileges in the public schema to the Hasura user.
GRANT ALL ON SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_hasura_username_xxx;

-- Grant select permissions on information_schema and pg_catalog to the Hasura
-- user.
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO xxx_db_hasura_username_xxx;

-- Allow the JORE3-Importer role to connect to the network database.
GRANT CONNECT ON DATABASE xxx_db_hasura_name_xxx TO xxx_db_jore3importer_username_xxx;

-- Grant the JORE3-Importer role to access the public schema and the objects and
-- functions created by extensions. Other schema-specific privileges are granted
-- in Hasura migrations.
GRANT USAGE ON SCHEMA public TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_jore3importer_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_jore3importer_username_xxx;
