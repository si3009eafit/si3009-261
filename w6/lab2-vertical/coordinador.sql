CREATE EXTENSION IF NOT EXISTS postgres_fdw;

-- Si ya existen los servers y mappings, esto no hace daño si no los recreas.
-- (Si necesitas recrearlos, puedo darte el script completo.)

-- 1) Foreign tables hacia cada fragmento
DROP FOREIGN TABLE IF EXISTS ft_clientes_publico;
DROP FOREIGN TABLE IF EXISTS ft_clientes_credito;

CREATE FOREIGN TABLE ft_clientes_publico (
  id        BIGINT,
  nombre    TEXT,
  direccion TEXT
)
SERVER madrid_srv
OPTIONS (schema_name 'public', table_name 'clientes_publico');

CREATE FOREIGN TABLE ft_clientes_credito (
  id            BIGINT,
  datos_credito TEXT
)
SERVER barcelona_srv
OPTIONS (schema_name 'public', table_name 'clientes_credito');

-- 2) Vista unificada (reconstrucción lógica)
DROP VIEW IF EXISTS clientes_dist;

CREATE VIEW clientes_dist AS
SELECT p.id, p.nombre, p.direccion, c.datos_credito
FROM ft_clientes_publico p
JOIN ft_clientes_credito c ON c.id = p.id;

SELECT * FROM clientes_dist ORDER BY id;

EXPLAIN (COSTS OFF)
SELECT * FROM clientes_dist WHERE id = 3;