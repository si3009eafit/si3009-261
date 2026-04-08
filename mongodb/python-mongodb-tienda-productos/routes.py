from flask import Blueprint, request, jsonify, current_app
from bson.objectid import ObjectId
from models import listar_productos, adicionar_producto, update_producto, delete_producto

producto_blueprint = Blueprint('producto', __name__)

@producto_blueprint.route('/', methods=['GET'])
def obtener_productos():
    productos = listar_productos(current_app.mongo)
    return jsonify(productos)

@producto_blueprint.route('/insertar', methods=['POST'])
def insertar_producto():
    data = request.json
    resultid = adicionar_producto(current_app.mongo, data)
    return jsonify({resultid})

@producto_blueprint.route('/actualizar/<id>', methods=['PATCH'])
def actualizar_producto(id):
    data = request.json
    result = update_producto(current_app.mongo,id,data)
    return jsonify({"documentos modificados": result}), 200

@producto_blueprint.route('/eliminar/<id>', methods=['DELETE'])
def eliminar_producto(id):
    resultado = delete_producto(current_app.mongo, id)
    return resultado