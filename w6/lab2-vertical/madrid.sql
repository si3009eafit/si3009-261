DROP TABLE IF EXISTS clientes_publico;

CREATE TABLE clientes_publico (
  id        BIGINT PRIMARY KEY,
  nombre    TEXT NOT NULL,
  direccion TEXT NOT NULL
);

INSERT INTO clientes_publico (id, nombre, direccion) VALUES
(1, 'Laura Díaz',     'Calle 10 #20-30'),
(2, 'Andrés Mejía',   'Carrera 50 #40-20'),
(3, 'Paula Rojas',    'Av. Siempre Viva 742'),
(4, 'Daniel Castro',  'Calle 80 #12-45'),
(5, 'Camila Herrera', 'Cra 30 #15-10');

SELECT * FROM clientes_publico ORDER BY id;