-- Create database and allow Hasura to create new schemas in it.
CREATE DATABASE xxx_db_timetables_name_xxx;
GRANT CREATE ON DATABASE xxx_db_timetables_name_xxx TO xxx_db_hasura_username_xxx;

-- Interval outputs by default are using the sql format ('3 4:05:06'). Here we
-- are switching to ISO 8601 format ('P3DT4H5M6S').
ALTER DATABASE xxx_db_timetables_name_xxx SET intervalstyle = 'iso_8601';

-- Switch database context to be able to add extensions there.
\connect xxx_db_timetables_name_xxx;

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
