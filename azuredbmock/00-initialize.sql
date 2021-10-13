
-- Initializations, which are needed locally, but not in the cloud / prod environments,
-- go here.

-- These users are created from the jore4-deploy repository in cloud environments.
CREATE USER xxx_db_auth_username_xxx PASSWORD 'xxx_db_auth_password_xxx';
CREATE USER xxx_db_jore3importer_username_xxx PASSWORD 'xxx_db_jore3importer_password_xxx';
CREATE USER xxx_db_hasura_username_xxx PASSWORD 'xxx_db_hasura_password_xxx';

-- Create the extensions used, see https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html
-- Create the extensions in the public schema, since we'd need to give additional privileges ("use schema") to any
-- user who wishes to use these in the future. Also, Hasura would require additional setup to be able to use the
-- extensions from another schema.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;

-- create the schema required by the hasura system
CREATE SCHEMA IF NOT EXISTS hdb_catalog;

-- make the user an owner of system schemas
ALTER SCHEMA hdb_catalog OWNER TO xxx_db_hasura_username_xxx;

-- allow hasura to create new schemas in migrations
GRANT CREATE ON DATABASE postgres TO xxx_db_hasura_username_xxx;
