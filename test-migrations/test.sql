-- tester script whether migrations mapped to the docker-entrypoint-initdb.d volume also get executed.
-- if yes, the following lines should appear on startup of the docker container:
--    |  ?column?
--    | ----------
--    |  OK
--    | (1 row)
SELECT 'OK';