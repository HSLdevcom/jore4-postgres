
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

-- allow hasura to create new schemas
GRANT CREATE ON DATABASE xxx_db_hasura_name_xxx TO xxx_db_hasura_username_xxx;

-- create database for auth and give ALL privileges to auth db user
CREATE DATABASE xxx_db_auth_name_xxx;
GRANT ALL ON DATABASE xxx_db_auth_name_xxx TO xxx_db_auth_username_xxx;

-- create database for jore3 importer and give ALL privileges to jore3importer db user
CREATE DATABASE xxx_db_jore3importer_name_xxx;
GRANT ALL ON DATABASE xxx_db_jore3importer_name_xxx TO xxx_db_jore3importer_username_xxx;
