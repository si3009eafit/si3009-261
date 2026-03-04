CREATE EXTENSION IF NOT EXISTS postgres_fdw;

DROP SERVER IF EXISTS madrid_srv CASCADE;
DROP SERVER IF EXISTS barcelona_srv CASCADE;

CREATE SERVER madrid_srv
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'pg_madrid', port '5432', dbname 'nodedb');

CREATE SERVER barcelona_srv
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'pg_barcelona', port '5432', dbname 'nodedb');

CREATE USER MAPPING IF NOT EXISTS FOR admin
  SERVER madrid_srv
  OPTIONS (user 'admin', password 'admin');

CREATE USER MAPPING IF NOT EXISTS FOR admin
  SERVER barcelona_srv
  OPTIONS (user 'admin', password 'admin');

DROP TABLE IF EXISTS empleados_dist CASCADE;

CREATE TABLE empleados_dist (
  id      BIGINT NOT NULL,
  nombre  TEXT NOT NULL,
  ciudad  TEXT NOT NULL,
  salario NUMERIC(10,2) NOT NULL CHECK (salario >= 0),
  PRIMARY KEY (ciudad, id)     -- clave distribuida simple
) PARTITION BY LIST (ciudad);

CREATE FOREIGN TABLE empleados_madrid_p
  PARTITION OF empleados_dist FOR VALUES IN ('Madrid')
  SERVER madrid_srv
  OPTIONS (schema_name 'public', table_name 'empleados');

CREATE FOREIGN TABLE empleados_barcelona_p
  PARTITION OF empleados_dist FOR VALUES IN ('Barcelona')
  SERVER barcelona_srv
  OPTIONS (schema_name 'public', table_name 'empleados');


SELECT * FROM empleados_dist ORDER BY ciudad, id;

EXPLAIN (COSTS OFF)
SELECT * FROM empleados_dist WHERE ciudad='Madrid';