DROP TABLE IF EXISTS clientes_credito;

CREATE TABLE clientes_credito (
  id           BIGINT PRIMARY KEY,
  datos_credito TEXT NOT NULL
);

INSERT INTO clientes_credito (id, datos_credito) VALUES
(1, 'VISA 1234-XXXX'),
(2, 'MC 5678-XXXX'),
(3, 'AMEX 9012-XXXX'),
(4, 'VISA 3456-XXXX'),
(5, 'MC 7890-XXXX');

SELECT * FROM clientes_credito ORDER BY id;
