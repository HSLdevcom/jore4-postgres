CREATE DATABASE xxx_db_auth_name_xxx;

-- Allow the auth role to connect and create new schemas.
GRANT CONNECT, CREATE ON DATABASE xxx_db_auth_name_xxx TO xxx_db_auth_username_xxx;

\connect xxx_db_auth_name_xxx;

-- Make the JORE4 admin role the owner of the public schema.
ALTER SCHEMA public OWNER TO CURRENT_USER;

-- Grant full schema access to the public schema to the auth role.
GRANT ALL ON SCHEMA public TO xxx_db_auth_username_xxx;
