from bson.objectid import ObjectId
from flask import jsonify

def listar_productos(mongo):
    productos = mongo.db.productos.find()
    resultado = []
    for p in productos:
        p['_id'] = str(p['_id'])
        resultado.append(p)
    return resultado

def adicionar_producto(mongo, data):
    result = mongo.db.productos.insert_one(data)
    return result.inserted_id


def update_producto(mongo, id, data):
    resultid = mongo.db.productos.update_one(
        {"_id": ObjectId(id)},
        {"$set": data}
    )
    return resultid.modified_count

def delete_producto(mongo,id):
    resultado = mongo.db.productos.delete_one({"_id": ObjectId(id)})
    if resultado.deleted_count == 0:
        return jsonify({"error": "Producto no encontrado"}), 404
    return jsonify({"mensaje": "Producto eliminado"}), 200