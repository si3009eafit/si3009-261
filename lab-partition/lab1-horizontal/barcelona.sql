DROP TABLE IF EXISTS empleados;

CREATE TABLE empleados (
  id      BIGSERIAL PRIMARY KEY,
  nombre  TEXT NOT NULL,
  ciudad  TEXT NOT NULL DEFAULT 'Barcelona' CHECK (ciudad = 'Barcelona'),
  salario NUMERIC(10,2) NOT NULL CHECK (salario >= 0)
);

INSERT INTO empleados (nombre, salario) VALUES
('María Torres', 38000),
('Luis Gómez', 45000),
('Javier Sánchez', 41000),
('Pedro Ramírez', 47000);

SELECT * FROM empleados ORDER BY id;
