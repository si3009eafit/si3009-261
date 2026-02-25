DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
  id      BIGSERIAL PRIMARY KEY,
  nombre  TEXT NOT NULL,
  ciudad  TEXT NOT NULL DEFAULT 'Madrid' CHECK (ciudad = 'Madrid'),
  salario NUMERIC(10,2) NOT NULL CHECK (salario >= 0)
);

INSERT INTO empleados (nombre, salario) VALUES
('Ana López', 35000),
('Carlos Ruiz', 42000),
('Sofía Martínez', 39000),
('Lucía Fernández', 36000);

SELECT * FROM empleados ORDER BY id;