-- This migration replicates initialization of the JORE4 main database in script scripts/ssh-to-bastion-host
-- in azure-infra-jore4aks repository

CREATE DATABASE xxx_db_jore4_main_name_xxx;

\connect xxx_db_jore4_main_name_xxx;


--------------------------
----- Create Schemas -----
--------------------------

CREATE SCHEMA IF NOT EXISTS network AUTHORIZATION xxx_db_hasura_username_xxx;
CREATE SCHEMA IF NOT EXISTS stopregistry AUTHORIZATION xxx_db_tiamat_username_xxx;
CREATE SCHEMA IF NOT EXISTS timetables AUTHORIZATION xxx_db_hasura_username_xxx;
CREATE SCHEMA IF NOT EXISTS hdb_catalog AUTHORIZATION xxx_db_hasura_username_xxx;

CREATE SCHEMA IF NOT EXISTS topology AUTHORIZATION xxx_db_tiamat_username_xxx;


-----------------------------
----- Create Extensions -----
-----------------------------

-- Extensions are created in public schema so the extensions are found from the search path
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


---------------------------------------
----- Configure Database Settings -----
---------------------------------------

-- Interval outputs by default are using the SQL format ('3 4:05:06'). Here we
-- switch to ISO 8601 format ('P3DT4H5M6S').
ALTER DATABASE xxx_db_jore4_main_name_xxx SET intervalstyle = 'iso_8601';


--------------------------------------------------
----- Grant Database Level Access Privileges -----
--------------------------------------------------

GRANT CONNECT, CREATE ON DATABASE xxx_db_jore4_main_name_xxx TO xxx_db_hasura_username_xxx;
GRANT CONNECT, CREATE ON DATABASE xxx_db_jore4_main_name_xxx TO xxx_db_tiamat_username_xxx;

GRANT CONNECT ON DATABASE xxx_db_jore4_main_name_xxx TO xxx_db_jore3importer_username_xxx;
GRANT CONNECT ON DATABASE xxx_db_jore4_main_name_xxx TO xxx_db_timetables_api_username_xxx;


-------------------------------------------------------
----- Grant Network Schema Level Access Privileges ----
-------------------------------------------------------

-- Grant required privileges to Hasura.
GRANT ALL ON SCHEMA network TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA network TO xxx_db_hasura_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA network TO xxx_db_hasura_username_xxx;

-- Grant the JORE3-Importer role to access the schema and the objects and
-- functions created by extensions. Other schema-specific privileges are granted
-- in Hasura migrations.
GRANT USAGE ON SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA network TO xxx_db_jore3importer_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA network TO xxx_db_jore3importer_username_xxx;


-------------------------------------------------------------
----- Grant Stop Registry Schema Level Access Privileges ----
-------------------------------------------------------------

-- Tiamat
GRANT ALL ON SCHEMA stopregistry TO xxx_db_tiamat_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA stopregistry TO xxx_db_tiamat_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA stopregistry TO xxx_db_tiamat_username_xxx;

-- Hasura
GRANT USAGE ON SCHEMA stopregistry TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA stopregistry TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA stopregistry GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;


--------------------------------------------------------
----- Grant Topology Schema Level Access Privileges ----
--------------------------------------------------------

-- See the beginning of the initial database migration in:
--  https://github.com/entur/tiamat/blob/master/src/main/resources/db/migration/V1__Base_version.sql
GRANT USAGE ON SCHEMA topology TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA topology TO xxx_db_hasura_username_xxx;
ALTER DEFAULT PRIVILEGES FOR USER xxx_db_tiamat_username_xxx IN SCHEMA topology GRANT SELECT ON TABLES TO xxx_db_hasura_username_xxx;


----------------------------------------------------------
----- Grant Timetables Schema Level Access Privileges ----
----------------------------------------------------------

GRANT ALL ON SCHEMA timetables TO xxx_db_hasura_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA timetables TO xxx_db_hasura_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA timetables TO xxx_db_hasura_username_xxx;

-- Allow the timetables-api role to use timetables schema
GRANT USAGE ON SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT SELECT ON ALL TABLES IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA timetables TO xxx_db_timetables_api_username_xxx;
