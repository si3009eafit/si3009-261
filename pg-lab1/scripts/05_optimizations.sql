-- 05_optimizations.sql
-- Secuencia recomendada de optimización para mostrar mejoras progresivas.
-- Ejecuta de forma incremental y vuelve a ejecutar 04_base_queries.sql después de cada "bloque".

-- 0) Asegurar estadísticas actualizadas
ANALYZE;

-- 1) Índices mínimos para FKs y filtros comunes (impacto fuerte en joins)
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_item_order_id ON order_item(order_id);
CREATE INDEX IF NOT EXISTS idx_order_item_product_id ON order_item(product_id);
CREATE INDEX IF NOT EXISTS idx_payment_order_id ON payment(order_id);

ANALYZE;

-- 2) Índice por rango temporal (consulta Q1)
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);

ANALYZE;

-- 3) Índice compuesto para dashboard (Q3): filtro por customer + orden por fecha
-- Postgres puede usarlo para evitar sort y limitar rápido
CREATE INDEX IF NOT EXISTS idx_orders_customer_date_desc ON orders(customer_id, order_date DESC);

ANALYZE;

-- 4) Optimizar Q5 (función sobre columna):
-- Alternativa A: reescribir consulta para usar rango (sargable) - recomendado (sin índice extra)
-- Alternativa B: índice por expresión (didáctico)
CREATE INDEX IF NOT EXISTS idx_orders_order_date_day_expr ON orders (date_trunc('day', order_date));

ANALYZE;

-- 5) Q4 (ILIKE '%..%'): para substring search, usa pg_trgm + GIN (muy didáctico)
-- Requiere extensión pg_trgm
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_product_name_trgm ON product USING gin (name gin_trgm_ops);

ANALYZE;

-- 6) Discusión "trade-off índice vs escritura":
-- Aumenta índices y mide INSERT/UPDATE. (No es código, es actividad experimental)
