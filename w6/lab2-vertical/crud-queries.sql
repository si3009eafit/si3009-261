
INSERT INTO clientes_publico (id, nombre, direccion)
VALUES (6, 'Mateo Salazar', 'Calle 55 #10-22');


INSERT INTO clientes_credito (id, datos_credito)
VALUES (6, 'VISA 7777-XXXX');

-- desde el coordinador

SELECT * FROM clientes_dist ORDER BY id;

-- fallos en un nodo barcelona


INSERT INTO clientes_publico (id, nombre, direccion)
VALUES (7, 'Inconsistente Uno', 'Calle 1 #1-1');

SELECT * FROM clientes_dist ORDER BY id;

-- No aparece el cliente 7 porque el JOIN no encuentra su parte sensible.