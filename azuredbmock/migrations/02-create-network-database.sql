-- Create the extensions used, see https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html
-- Create the extensions in the public schema, since we'd need to give additional privileges ("use schema") to any
-- user who wishes to use these in the future. Also, Hasura would require additional setup to be able to use the
-- extensions from another schema.
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

-- Allow Hasura to create new schemas.
GRANT CREATE ON DATABASE xxx_db_hasura_name_xxx TO xxx_db_hasura_username_xxx;
