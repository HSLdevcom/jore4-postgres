CREATE DATABASE xxx_db_jore3importer_name_xxx;

-- Allow the jore3importer role to connect and create new schemas.
GRANT CONNECT, CREATE ON DATABASE xxx_db_jore3importer_name_xxx TO xxx_db_jore3importer_username_xxx;

\connect xxx_db_jore3importer_name_xxx;

-- Make the JORE4 admin role the owner of the public schema.
ALTER SCHEMA public OWNER TO CURRENT_USER;

-- Create the extensions that JORE3-Importer needs. In PostgreSQL v15 server,
-- an ordinary user (without admin roles) may not be able to create extensions.
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

-- Grant privileges in the public schema to the jore3importer role.
GRANT USAGE ON SCHEMA public TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_jore3importer_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_jore3importer_username_xxx;

-- Grant permission on the pg_catalog schema to conditionally create an
-- extension if the extension is not already created. This must be granted so
-- that the JORE3-Importer role can conditionally create the extension depending
-- on which database is involved (there are several in the importer's test setup).
GRANT SELECT ON TABLE pg_catalog.pg_extension TO xxx_db_jore3importer_username_xxx;
