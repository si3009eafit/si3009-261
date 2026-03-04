# Lab de base de datos distribuidas básica con posgrestsql, sobre particionamiento:

## Descripción: Simulación de 2 nodos PostgreSQL (Madrid y Barcelona) usando postgres_fdw, con un coordinador que expone una tabla distribuida particionada cuyos fragmentos son foreign partitions (cada partición vive físicamente en un nodo distinto).

## Alcances:

* datos están en dos PostgreSQL diferentes (2 contenedores).
* Desde el coordinador, se consulta como si fuera una sola tabla.
* El INSERT en la tabla “global” se enruta y se ejecuta hacia el nodo correcto.

## ambiente:

* Docker + docker-compose.yml de postgresql 18+
* cliente pgadmin

## [docker-compose.yml](docker-compose.yml)

## DDL+datos para creación de tablas en Madrid

[madrid.sql](madrid.sql)

## DDL+datos para creación de tablas en Barcelona

[barcelona.sql](barcelona.sql)

## Coordinador

* postgres_fdw
* servers madrid_srv, barcelona_srv
* user mapping
* tabla particionada empleados_dist
* foreign partitions empleados_madrid_p, empleados_barcelona_p

[coordinador.sql](coordinador.sql)

## insertar datos desde el coordinador

[inserts.sql](inserts.sql)

## consultas

[queries.sql](queries.sql)

## notas finales

* cada nodo usa BIGSERIAL, los id pueden colisionar entre nodos. Por eso la PK global es (ciudad, id).
* Para un sistema “más real”, podría usar UUID global (con gen_random_uuid())