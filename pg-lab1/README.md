# pg-lab1

## Orden recomendado
1. `01_schema.sql` -> crea tablas (sin índices secundarios)
2. `02_generate_small.sql` -> datos pequeños (rápido) + ANALYZE
3. `03_generate_big.sql` en vez del small para probar con millones de registros
4. `04_queries.sql` -> consultas base con EXPLAIN ANALYZE
5. `05_optimizations.sql` -> aplica optimizaciones incrementalmente y vuelve a ejecutar `04_queries.sql`

## Procedimiento
- plan de ejecución y tiempos antes/después.
- En Postgres, prueba `EXPLAIN (ANALYZE, BUFFERS)` para ver IO.
- Si usas dataset grandes, considera ejecutar por bloques y medir impacto de:
  - índices simples vs compuestos
  - estadísticas (ANALYZE)
  - índices por expresión (date_trunc)
  - GIN + pg_trgm para búsquedas por substring
  - etc
- etc
