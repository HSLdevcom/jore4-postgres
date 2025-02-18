-- These database roles are also created in the azure-infra-jore4aks (Azure
-- DevOps) repository.
CREATE USER xxx_db_auth_username_xxx PASSWORD 'xxx_db_auth_password_xxx';
CREATE USER xxx_db_jore3importer_username_xxx PASSWORD 'xxx_db_jore3importer_password_xxx';
CREATE USER xxx_db_hasura_username_xxx PASSWORD 'xxx_db_hasura_password_xxx';
CREATE USER xxx_db_tiamat_username_xxx PASSWORD 'xxx_db_tiamat_password_xxx';
CREATE USER xxx_db_timetables_api_username_xxx PASSWORD 'xxx_db_timetables_api_password_xxx';

-- Make the hasura role a member of jore3importer role because both roles must
-- have ownership of tables and sequences in the default database (network and
-- routes) since both are responsible for populating and truncating tables in
-- the aforementioned database. In particular, sequence reset requires an
-- ownership and cannot be granted as a privilege.
GRANT xxx_db_jore3importer_username_xxx TO xxx_db_hasura_username_xxx;
