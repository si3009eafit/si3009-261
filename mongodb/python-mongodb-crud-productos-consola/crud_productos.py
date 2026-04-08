from pymongo import MongoClient
from bson.objectid import ObjectId

# Conectar a MongoDB local
client = MongoClient("mongodb://localhost:27017/")
db = client["tienda"]
productos = db["productos"]

def crear_producto(nombre, precio):
    producto = {"nombre": nombre, "precio": precio}
    result = productos.insert_one(producto)
    print(f"Producto insertado con ID: {result.inserted_id}")

def listar_productos():
    for p in productos.find():
        print(f"{p['_id']} - {p['nombre']} - ${p['precio']}")

def actualizar_producto(id_str, nuevo_nombre, nuevo_precio):
    result = productos.update_one(
        {"_id": ObjectId(id_str)},
        {"$set": {"nombre": nuevo_nombre, "precio": nuevo_precio}}
    )
    if result.matched_count:
        print("Producto actualizado.")
    else:
        print("No se encontró el producto.")

def eliminar_producto(id_str):
    result = productos.delete_one({"_id": ObjectId(id_str)})
    if result.deleted_count:
        print("Producto eliminado.")
    else:
        print("No se encontró el producto.")

if __name__ == "__main__":
    while True:
        print("\n1. Crear\n2. Listar\n3. Actualizar\n4. Eliminar\n5. Salir")
        opcion = input("Seleccione una opción: ")

        if opcion == "1":
            nombre = input("Nombre del producto: ")
            precio = float(input("Precio: "))
            crear_producto(nombre, precio)

        elif opcion == "2":
            listar_productos()

        elif opcion == "3":
            id_str = input("ID del producto a actualizar: ")
            nuevo_nombre = input("Nuevo nombre: ")
            nuevo_precio = float(input("Nuevo precio: "))
            actualizar_producto(id_str, nuevo_nombre, nuevo_precio)

        elif opcion == "4":
            id_str = input("ID del producto a eliminar: ")
            eliminar_producto(id_str)

        elif opcion == "5":
            break

        else:
            print("Opción no válida.")
