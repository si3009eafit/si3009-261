# Lab de replicación
## 1. ver configuración del lider:

    leader/conf/postgresql.conf

    leader/conf/pg_hba.conf

## 2. SQL de iniciación de Leader

    leader/init/00_create_replication_user.sql
    leader/init/10_app_schema_and_seed.sql

## 3. Configuración de replica

    replica/conf/postgresql.conf

## 4. script de inicio de replica (auto-basebackup)

    replica/scripts/replica-entrypoint.sh
    chmod +x replica/scripts/replica-entrypoint.sh

## 5. ejecutar el docker-compose.yml para que simule los 3 nodos

    docker compose up -d

## 6. Verificar que el leader tiene réplica conectada (en el lider)

    SELECT client_addr, state, sync_state, write_lag, flush_lag, replay_lag FROM pg_stat_replication;

    Debe mostrar una fila con state='streaming'

## 7. Probar replicación de datos (write en leader → read en replica)

    -- insertar en el leader:
    INSERT INTO sensor_events(sensor_id, reading) VALUES ('S-003', 33.33);

    -- consultar en la replica (puerto 5433):
    SELECT * FROM sensor_events ORDER BY id DESC LIMIT 5;

    -- intentar escribir en la replica y mirar el error:
    INSERT INTO sensor_events(sensor_id, reading) VALUES ('S-XXX', 1.0);

## 8. Medir "replication lag"

    -- en replica
    SELECT now() - pg_last_xact_replay_timestamp() AS replay_delay;

# RETO 1:

    En el leader, ejecuta 200 inserts en loop (usar SQL generate_series)
    Observa pg_stat_replication en leader y replay_delay en replica
    Contestar:
    ¿Qué significa “streaming”?
    ¿Qué diferencia hay entre write/flush/replay lag?
    ¿Qué pasa si la réplica se cae y vuelve?

    -- SQL generación de datos
    INSERT INTO sensor_events(sensor_id, reading)
        SELECT 'S-BULK', (random()*100)::numeric(10,2)
        FROM generate_series(1,200);

# RETO 2:

    ADAPTAR ESTE EJEMPLO A 2 REPLICAR Y UN LEADER
    REALIZAR PROMOCIÓN MANUAL (pg_ctl promote)