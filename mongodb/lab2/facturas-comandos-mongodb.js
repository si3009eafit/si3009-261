# ingresar a través de la interfaz Mongo Shell al servidor MongoDB

use si3009db

db.facturas.help()

show dbs

show collections

-- mutliples lineas --  
db.facturas.insertOne({  "nroFactura": 1000,
    "cliente": {
        "nombre": "Marina",
        "apellido": "Martinez",
        "clid": 12345,
        "region": "CENTRO"
    },
    "condPago": "CONTADO",
    "fechaEmision": ISODate("2014-02-20T00:00:00.000Z"),
    "fechaVencimiento": ISODate("2014-02-20T00:00:00.000Z"),
    "items": [
        {   "producto": " CORREA 12mm",
            "cantidad": 11,
            "precio": 18.0
            
        },
        {   "producto": "TALADRO 12mm",
            "cantidad": 1,
            "precio": 490.0
        }
        ]
})

-- una sola linea --
db.facturas.insertOne({ "nroFactura": 1001, "cliente": { "nombre": "Martin", "apellido": "Zavasi", "clid": 12346, "region": "SUR" }, "condPago": "30 dias", "fechaEmision": ISODate("2014-02-20T00:00:00.000Z"), "fechaVencimiento": ISODate("2014-03-22T00:00:00.000Z"), "items": [ { "producto": "CORREA 10mm", "cantidad": 2, "precio": 134.0 } ] })

db.facturas.insertOne({ "nroFactura": 1002, "cliente": { "nombre": "Martin", "apellido": "Zavasi", "clid": 12346, "region": "SUR" }, "condPago": "CONTADO", "fechaEmision": ISODate("2014-02-20T00:00:00.000Z"), "fechaVencimiento": ISODate("2014-02-20T00:00:00.000Z"), "items": [ { "producto": "TUERCA 2mm", "cantidad": 6, "precio": 60.0 }, { "producto": "CORREA 10mm", "cantidad": 12, "precio": 134.0 } ] })

db.facturas.find()

db.facturas.countDocuments()

db.facturas.dataSize()

db.facturas.find({"cliente.apellido":"Martinez"})

db.facturas.find().limit(2)

db.facturas.find().skip(2)

db.facturas.find().pretty()

db.facturas.find().limit(2).skip(2).pretty()

db.facturas.find({"cliente.apellido": "Martinez"}, {"cliente.clid": 1, "cliente.region": 1})

db.facturas.find({"cliente.apellido":"Zavasi"}).pretty()

db.facturas.find({"cliente.apellido":"Zavasi", "nroFactura":1001}).pretty()

db.facturas.find().sort({nroFactura:1})

db.facturas.find().sort({nroFactura:-1})

db.facturas.countDocuments({ nroFactura: { $gt: 1465 } })






