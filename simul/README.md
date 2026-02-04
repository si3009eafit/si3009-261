## simulador de transacciones a bases de datos

    pip install psycopg[binary]

## Local con docker:

python simul-eafitshop.py \
  --host localhost --db labdb --user labuser --password labpass \
  --concurrency 8 --warmup 10 --duration 60

## AWS RDS:

python simul-eafitshop.py \
  --host <endpoint-rds> --db labdb --user <user> --password <pass> --sslmode require \
  --concurrency 8 --warmup 10 --duration 60

## Recomendaciones:

### Calentamiento y repetición

--Usa warmup para evitar medir “cache cold”.
--Corre 3 veces y reporta promedio / rango.

### Latencia “de aplicación”

Este script mide latencia end-to-end de una transacción (lo que importa en OLTP).

* Control de colisiones de IDs

### Usa order_id_base alto para no chocar con el dataset ya cargado.

Ver bloqueos y quien bloquea:

SELECT
  a.pid,
  a.state,
  a.wait_event_type,
  a.wait_event,
  left(a.query, 80) AS query
FROM pg_stat_activity a
WHERE a.datname = current_database()
ORDER BY a.query_start DESC
LIMIT 20;

para locks:

SELECT locktype, relation::regclass, mode, granted, count(*)
FROM pg_locks
GROUP BY 1,2,3,4
ORDER BY count(*) DESC;



