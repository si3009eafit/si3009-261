-- Base de datos: labdb ya se crea con POSTGRES_DB

CREATE TABLE IF NOT EXISTS public.sensor_events (
  id          BIGSERIAL PRIMARY KEY,
  sensor_id   TEXT NOT NULL,
  reading     NUMERIC(10,2) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO public.sensor_events(sensor_id, reading)
VALUES
  ('S-001', 10.50),
  ('S-002', 22.10),
  ('S-001', 11.10);