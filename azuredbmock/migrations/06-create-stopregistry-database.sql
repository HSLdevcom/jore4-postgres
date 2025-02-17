CREATE DATABASE xxx_db_tiamat_name_xxx;

-- Allow Tiamat to connect and create new schemas.
GRANT CONNECT, CREATE ON DATABASE xxx_db_tiamat_name_xxx TO xxx_db_tiamat_username_xxx;

-- Switch database context to initialise it to the state where Tiamat can use
-- it.
\connect xxx_db_tiamat_name_xxx;

-- Make the JORE4 admin role the owner of the public schema.
ALTER SCHEMA public OWNER TO CURRENT_USER;

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;

-- Grant required privileges in the public schema to Tiamat.
GRANT ALL ON SCHEMA public TO xxx_db_tiamat_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_tiamat_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO xxx_db_tiamat_username_xxx;

-- Create "topology" schema and install the "postgis_topology" extension to it.
-- The Tiamat role needs ownership to the schema and its tables.
CREATE SCHEMA IF NOT EXISTS topology;
CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;
ALTER SCHEMA topology OWNER TO xxx_db_tiamat_username_xxx;
-- The "postgis_topology" extension creates two tables.
ALTER TABLE topology.layer OWNER TO xxx_db_tiamat_username_xxx;
ALTER TABLE topology.topology OWNER TO xxx_db_tiamat_username_xxx;

-- Grant Hasura read permissions to the stop registry database.
GRANT CONNECT ON DATABASE xxx_db_tiamat_name_xxx TO xxx_db_hasura_username_xxx;

GRANT USAGE ON SCHEMA public TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA public GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;

GRANT USAGE ON SCHEMA topology TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA topology GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;
