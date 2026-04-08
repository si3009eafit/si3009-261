const express = require("express");
const mongoose = require("mongoose");
const productoRouter = require("./routes/productoRoutes.js");

const app = express();

app.use(express.json());

const mongoatlas = "mongodb+srv://root:*******@cluster0.jd1xd.mongodb.net/?retryWrites=true&w=majority";

const mongolocal = "mongodb://localhost/tienda";

mongoose.connect(mongolocal);

app.use('/productos', productoRouter);

app.listen(3000, () => {
  console.log("Server is running...");
});