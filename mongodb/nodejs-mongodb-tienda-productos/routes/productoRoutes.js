const express = require("express");
const productoModel = require("../models/producto");
const app = express();

// consultar todos los productos
// URI: /productos
app.get("/", async (request, response) => {
  const productos = await productoModel.find({});

  try {
    response.send(productos);
  } catch (error) {
    response.status(500).send(error);
  }
});

// insert 
// URI: /productos/insertar
app.post("/insertar", async (request, response) => {
    const producto = new productoModel(request.body);
  
    try {
      await producto.save();
      response.send(producto);
    } catch (error) {
      response.status(500).send(error);
    }
  });


// update
// URI: /productos/actualizar/{id}
app.patch("/actualizar/:id", async (request, response) => {
    try {
      const producto = new productoModel(request.body);
      await productoModel.findByIdAndUpdate(request.params.id, request.body);
      await productoModel.save();
      response.send(producto);
    } catch (error) {
      response.status(500).send(error);
    }
  });

// delete
// URI: /productos/eliminar/{id}
app.delete("/eliminar/:id", async (request, response) => {
    try {
      const producto = await productoModel.findByIdAndDelete(request.params.id);
  
      if (!producto) response.status(404).send("No producto found");
      response.status(200).send();
    } catch (error) {
      response.status(500).send(error);
    }
  });

module.exports = app;