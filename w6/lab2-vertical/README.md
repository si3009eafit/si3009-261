## fragmentación vertical distribuido usando postgres_fdw, manteniendo el mismo esquema de 3 contenedores (coordinator + madrid + barcelona). Vamos a simular:

* Nodo Madrid: clientes_publico (datos frecuentes: id, nombre, direccion)
* Nodo Barcelona: clientes_credito (datos sensibles: id, datos_credito)
* Coordinador: vista unificada clientes_dist que reconstruye el “registro lógico” con JOIN federado.
* FK cross-node no se puede garantizar con constraints nativas (cada BD es independiente). Eso es precisamente parte de la lección: integridad referencial pasa a ser responsabilidad de la app o de mecanismos adicionales.

## Nodo Madrid - datos publicos

[madrid.sql](madrid.sql)

## Nodo Barcelona - datos sensibles

[barcelona.sql](barcelona.sql)

## Nodo Coordinador

[coordinador.sql](coordinador.sql)

## Operaciones CRUD y transacciones distribuidas

### Insert consistente (manual, dos nodos)

[crud-queries.sql](crud-queries.sql)

### preguntas finales por fallos en alguno de los nodos

* ¿Dónde queda la “verdad”?
* ¿Qué vista se debe ofrecer al usuario?
* ¿Cómo se repara?
* ¿Es mejor INNER JOIN o LEFT JOIN?

    * esto nos permite ver faltantes:

        DROP VIEW IF EXISTS clientes_dist_debug;

        CREATE VIEW clientes_dist_debug AS
        SELECT p.id, p.nombre, p.direccion, c.datos_credito,
            (c.id IS NULL) AS falta_credito
        FROM ft_clientes_publico p
        LEFT JOIN ft_clientes_credito c ON c.id = p.id;

        SELECT * FROM clientes_dist_debug ORDER BY id;

    * que pasa si en las vistas vemos faltantes?

    Vista actualizable con Trigger (en postgresql, pero depende de motor a motor):

        INSERT a la vista → inserta en Madrid y Barcelona
        Si falla Barcelona → compensación (borrar en Madrid)

# preguntas de fondo

    1. Integridad referencial distribuida: no hay FK global nativa entre dos PostgreSQL distintos.
    2. Join distribuido: el coordinador debe traer datos de ambos nodos; latencia importa.
    3. Consistencia: ¿qué pasa entre el insert público y el insert sensible?
    4. Transacciones: 2PC vs SAGA para garantizar atomicidad.
    5. Seguridad: separación física de datos sensibles (compliance).