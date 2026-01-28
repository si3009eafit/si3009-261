-- 06_measurement_helpers.sql
-- Extensiones y ayudas para medición en PostgreSQL (en RDS también suele funcionar si está permitida)

-- Habilita pg_stat_statements (requiere shared_preload_libraries; en Docker local sí lo activamos por config,
-- en RDS se hace con parameter group). Si no está disponible, este bloque fallará; ignóralo.
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Ajustes recomendados para la sesión del laboratorio (no globales)
-- Nota: aumentar work_mem puede cambiar estrategias de join/aggregation: útil para discusión.
-- SET work_mem = '128MB';

-- Verifica tamaño de tablas/índices
-- SELECT relname, pg_size_pretty(pg_total_relation_size(relid)) AS total_size
-- FROM pg_catalog.pg_statio_user_tables
-- ORDER BY pg_total_relation_size(relid) DESC;

-- Consultas "top" por tiempo (requiere pg_stat_statements)
-- SELECT query, calls, total_time, mean_time, rows
-- FROM pg_stat_statements
-- ORDER BY total_time DESC
-- LIMIT 20;
