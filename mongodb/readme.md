importar un archivo completo de json a un servidor local:

emontoya$ mongoimport --uri mongodb://localhost/tienda --collection countries --type json --jsonArray --file countries.json

importar un archivo completo de json a un servidor mongo-atlas:

mongoimport --uri mongodb+srv://root:********@cluster0.jd1xd.mongodb.net/tienda?retryWrites=true&w=majority --collection countries --type json --jsonArray --file countries.json
