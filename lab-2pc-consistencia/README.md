•Utilizando alguna de las IA de su preferencia, diseñe e implemente un laboratorio con al menos 3 nodos de bases de datos y un escenario donde pueda aplicar y materializar los diferentes modelos de consistencia y transacciones distribuidas, adicionamente podría requerir algun nivel de replicación de los conceptos vistos en la clase pasada.


•Se recomienda implementarlo en docker, para más rápidamente lograr la escalabilidad y la BD distribuida


•Simular operaciones normales y fallos, mecanismos de tolerancia a fallos, fail-over y fail-back.


•Realizar el lab para 2 bases de datos:


    •Obligatoria con Postgresql con 3 bases de datos independientes para probar 2PC. Explique: ¿Cómo se garantiza consistencia estricta en postgresql con replicación sincrónica y     transacciones distribuidas? Compararlo con los modelos de ORACLE

    •Escoger entre Cassandra (consistencia eventual, consistencia tunable, quorum reads/writes) o CockroachDB (consistencia estricta, replicación raft, transacciones distribuidas serializables)

    •Responder: Como se puede o que limitaciones tiene un modelo multi-master para lograr consistencia estricta con replicación sincrónica?

•Se recomienda realizarlo en AWS EC2.

•Crear o adicionar el lab a un repo github, que permita ser replicable y entendible por los otros alumnos y profesor.

•Al final, algunos grupos expondrán su laboratorio.

•Realizar en la documentación README.md las principales conclusiones, limitaciones y proyecciones que tiene este lab.