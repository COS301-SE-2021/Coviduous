const express = require("express");
const bodyParser = require("body-parser");
//const db = require("./queries");
const host = db.host;
const port = db.port;

const app = express();

app.use(bodyParser.json());

app.use(
  bodyParser.urlencoded({
    extended: true,
  })
);

app.listen(8000, function() {
	console.log("Server is running on %s port %i.", host, port);
});

app.post('/create-user', db.createUser);
app.get('/users', db.getUsers);