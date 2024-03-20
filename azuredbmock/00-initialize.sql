
-- Initializations, which are needed locally, but not in the cloud / prod environments,
-- go here.

-- These users are created from the jore4-deploy repository in cloud environments.
CREATE USER xxx_db_auth_username_xxx PASSWORD 'xxx_db_auth_password_xxx';
CREATE USER xxx_db_jore3importer_username_xxx PASSWORD 'xxx_db_jore3importer_password_xxx';
CREATE USER xxx_db_hasura_username_xxx PASSWORD 'xxx_db_hasura_password_xxx';
CREATE USER xxx_db_tiamat_username_xxx PASSWORD 'xxx_db_tiamat_password_xxx';
CREATE USER xxx_db_timetables_api_username_xxx PASSWORD 'xxx_db_timetables_api_password_xxx';

-- Create the extensions used, see https://hasura.io/docs/latest/graphql/core/deployment/postgres-requirements.html
-- Create the extensions in the public schema, since we'd need to give additional privileges ("use schema") to any
-- user who wishes to use these in the future. Also, Hasura would require additional setup to be able to use the
-- extensions from another schema.
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- allow hasura to create new schemas
GRANT CREATE ON DATABASE xxx_db_hasura_name_xxx TO xxx_db_hasura_username_xxx;

-- create database for auth and give ALL privileges to auth db user
CREATE DATABASE xxx_db_auth_name_xxx;
GRANT ALL ON DATABASE xxx_db_auth_name_xxx TO xxx_db_auth_username_xxx;

-- Make hasura role a member of jore3importer role because both roles must have
-- ownership of tables and sequences since both are responsible for populating
-- and truncating tables. In particular, sequence reset requires an ownership
-- and cannot be granted as a privilege.
GRANT xxx_db_jore3importer_username_xxx TO xxx_db_hasura_username_xxx;

-- create database for jore3 importer and give ALL privileges to jore3importer db user
CREATE DATABASE xxx_db_jore3importer_name_xxx;
GRANT ALL ON DATABASE xxx_db_jore3importer_name_xxx TO xxx_db_jore3importer_username_xxx;

-- create database for timetables and allow hasura to create new schemas in it
CREATE DATABASE xxx_db_timetables_name_xxx;
GRANT CREATE ON DATABASE xxx_db_timetables_name_xxx TO xxx_db_hasura_username_xxx;

-- create database for stop registry and give ALL privileges to Tiamat in it
CREATE DATABASE xxx_db_tiamat_name_xxx;
GRANT ALL ON DATABASE xxx_db_tiamat_name_xxx TO xxx_db_tiamat_username_xxx;

-- switch database context to timetables db to be able to add extensions there
\connect xxx_db_timetables_name_xxx;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- interval outputs by default are using the sql format ('3 4:05:06'). Here we are switching to ISO 8601 format ('P3DT4H5M6S')
ALTER DATABASE xxx_db_timetables_name_xxx SET intervalstyle = 'iso_8601';

-- switch database context to stop db to initialize it to the state where tiamat can use it
\connect xxx_db_tiamat_name_xxx;
CREATE SCHEMA topology;
ALTER SCHEMA topology OWNER TO xxx_db_tiamat_username_xxx;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;
-- the postgis_topology creates two tables
ALTER TABLE topology.layer OWNER TO xxx_db_tiamat_username_xxx;
ALTER TABLE topology.topology OWNER TO xxx_db_tiamat_username_xxx;

-- grant hasura user read permissions to the tiamat database
GRANT CONNECT ON DATABASE xxx_db_tiamat_name_xxx TO xxx_db_hasura_username_xxx;

GRANT USAGE ON SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA public GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;

GRANT USAGE ON SCHEMA topology TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA topology GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;
