CREATE DATABASE xxx_db_timetables_name_xxx;

-- Allow Hasura to connect and create new schemas.
GRANT CONNECT, CREATE ON DATABASE xxx_db_timetables_name_xxx TO xxx_db_hasura_username_xxx;

-- Interval outputs by default are using the sql format ('3 4:05:06'). Here we
-- are switching to ISO 8601 format ('P3DT4H5M6S').
ALTER DATABASE xxx_db_timetables_name_xxx SET intervalstyle = 'iso_8601';

-- Switch database context to be able to add extensions there.
\connect xxx_db_timetables_name_xxx;

-- Make the JORE4 admin role the owner of the public schema.
ALTER SCHEMA public OWNER TO CURRENT_USER;

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

-- Grant required privileges in the public schema to Hasura.
GRANT ALL ON SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_hasura_username_xxx;

-- Grant select permissions on information_schema and pg_catalog to Hasura.
GRANT SELECT ON ALL TABLES IN SCHEMA information_schema TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA pg_catalog TO xxx_db_hasura_username_xxx;

-- Allow the timetables-api role to connect to the timetables database.
GRANT CONNECT ON DATABASE xxx_db_timetables_name_xxx TO xxx_db_timetables_api_username_xxx;

-- Grant the timetables-api role to access the public schema and the objects and
-- functions created by extensions. Other schema-specific privileges are granted
-- in Hasura migrations.
GRANT USAGE ON SCHEMA public TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_timetables_api_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_timetables_api_username_xxx;
