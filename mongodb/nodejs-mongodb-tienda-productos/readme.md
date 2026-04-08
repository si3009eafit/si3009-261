
# NodeJS + MongoDB Base de datos: Tienda, Colección: Productos

## Instalar dependencias

Ejecuta:

    `npm install`

## Base de datos
Instalar mongodb más algún cliente CLI o app como Studio 3T.
registros de prueba: 'productos.json'
  
## Ejecutar

Para ejecutar en modo debug:

Para ejecutar normalmente:  

    `node server.js`

Después, visita:

utilice un cliente postman en web o instalado en tu máquina para probar todos los API REST (CRUD):

    consultar todos los productos
    URI: /productos
    Método: GET

        ej: http://localhost:3000/productos

    insert 
    URI: /productos/insertar
    Método: POST

        ej: http://localhost:3000/productos/insertar

    update
    URI: /productos/actualizar/{id}
    Método: PATCH

        ej: http://localhost:3000/productos/actualizar/6355d57191f8c218e41ba380

    delete
    URI: /productos/eliminar/{id}
    Método: DELETE

        ej: http://localhost:3000/productos/eliminar/6355d57191f8c218e41ba380
