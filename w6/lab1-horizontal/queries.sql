SELECT * FROM empleados ORDER BY id;
SELECT * FROM empleados ORDER BY id;

-- Partition pruning ( un nodo)
EXPLAIN (ANALYZE, COSTS OFF)
SELECT * FROM empleados_dist WHERE ciudad='Madrid';

-- Agregación global ( ambos nodos)
EXPLAIN (ANALYZE, COSTS OFF)
SELECT ciudad, AVG(salario) FROM empleados_dist GROUP BY ciudad;

-- “Join distribuido” (crear otra tabla en coordinator)
-- tabla local bonos(ciudad, porcentaje) y unirla con empleados_dist para ver el costo.


