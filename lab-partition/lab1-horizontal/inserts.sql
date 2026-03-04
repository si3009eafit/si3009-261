-- Insertar en Madrid
INSERT INTO empleados_dist (id, nombre, ciudad, salario)
VALUES (1001, 'Nuevo Madrid', 'Madrid', 50000);

-- Insertar en Barcelona
INSERT INTO empleados_dist (id, nombre, ciudad, salario)
VALUES (2001, 'Nuevo Barcelona', 'Barcelona', 52000);

-- Ver todo desde el coordinador
SELECT * FROM empleados_dist ORDER BY ciudad, id;
