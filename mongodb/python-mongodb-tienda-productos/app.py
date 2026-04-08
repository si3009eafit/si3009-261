from flask import Flask
from flask_pymongo import PyMongo
from routes import producto_blueprint

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://localhost:27017/tienda"
mongo = PyMongo(app)

# Inyectar objeto mongo en rutas
app.mongo = mongo

app.register_blueprint(producto_blueprint, url_prefix='/productos')

if __name__ == '__main__':
    app.run(port=3000, debug=True)