-- Crea el usuario de replicación (necesario para pg_basebackup y streaming replication)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'replicator') THEN
    CREATE ROLE replicator WITH
      REPLICATION
      LOGIN
      PASSWORD 'replica_pass';
  END IF;
END$$;

-- (Opcional, útil para labs) Crear un slot de replicación físico
-- Evita que se reciclen WALs si la réplica se queda atrás.
-- Nota: si borras el slot, la réplica puede requerir nuevo basebackup.
SELECT * FROM pg_create_physical_replication_slot('replica_slot_1')
WHERE NOT EXISTS (SELECT 1 FROM pg_replication_slots WHERE slot_name = 'replica_slot_1');