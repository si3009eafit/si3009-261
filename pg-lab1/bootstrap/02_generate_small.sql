-- 02_generate_small.sql
-- Dataset "pequeño" (rápido): útil para validar pipeline y consultas antes de ir a big data.

-- Recomendación: ejecuta en pgAdmin/CloudBeaver y luego ANALYZE.

-- Parámetros
-- Customers: 50k
-- Products: 10k
-- Orders: 200k
-- OrderItems: ~800k
-- Payments: 160k

-- Customers
INSERT INTO customer (customer_id, name, email, city, created_at)
SELECT
  gs AS customer_id,
  'Customer ' || gs,
  'customer' || gs || '@example.com',
  (ARRAY['Medellín','Bogotá','Cali','Barranquilla','Bucaramanga','Cartagena','Manizales','Pereira'])[1 + (random()*7)::int],
  now() - (random() * interval '5 years')
FROM generate_series(1, 50000) gs;

-- Products
INSERT INTO product (product_id, name, category, price)
SELECT
  gs AS product_id,
  'Product ' || gs,
  (ARRAY['Electrónica','Hogar','Deportes','Libros','Moda','Juguetes','Salud','Alimentos'])[1 + (random()*7)::int],
  round((random()*490 + 10)::numeric, 2)
FROM generate_series(1, 10000) gs;

-- Orders
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
SELECT
  gs AS order_id,
  1 + (random()*49999)::bigint AS customer_id,
  now() - (random() * interval '3 years') AS order_date,
  (ARRAY['CREATED','PAID','SHIPPED','COMPLETED','CANCELLED'])[1 + (random()*4)::int]::order_status,
  round((random()*500 + 10)::numeric, 2)
FROM generate_series(1, 200000) gs;

-- Order Items (4 items por orden en promedio)
INSERT INTO order_item (order_item_id, order_id, product_id, quantity, unit_price)
SELECT
  gs AS order_item_id,
  1 + ((gs-1) / 4)::bigint AS order_id,
  1 + (random()*9999)::bigint AS product_id,
  1 + (random()*3)::int AS quantity,
  round((random()*300 + 5)::numeric, 2) AS unit_price
FROM generate_series(1, 800000) gs;

-- Payments (80% de órdenes)
INSERT INTO payment (payment_id, order_id, payment_date, payment_method, payment_status)
SELECT
  gs AS payment_id,
  gs AS order_id,
  (SELECT order_date FROM orders o WHERE o.order_id = gs) + (random() * interval '2 hours'),
  (ARRAY['CARD','PSE','CASH_ON_DELIVERY','TRANSFER'])[1 + (random()*3)::int],
  (ARRAY['APPROVED','REJECTED','PENDING'])[1 + (random()*2)::int]
FROM generate_series(1, 160000) gs;

ANALYZE;
