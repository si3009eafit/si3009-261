const mongoose = require("mongoose");

const ProductoSchema = new mongoose.Schema({
  nombre: String,
  precio: Number
});

const Producto = mongoose.model("productos", ProductoSchema);

module.exports = Producto;