let functions = require("firebase-functions");
let express = require('express');
let cors = require('cors');
let app = express();

const swaggerJSDoc = require('swagger-jsdoc');
const swaggerUI = require('swagger-ui-express');

app.use(cors({ origin: true }));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

//Swagger Configuration
const swaggerOptions = {
    swaggerDefinition: {
        info: {
            title:'Coviduous API',
            version:'1.0.0'
        }
    },
    apis:['./controllers/*.js'],
    servers: ['http://localhost:5002/coviduous-api/us-central1/app']
  }
  
const swaggerDocs = swaggerJSDoc(swaggerOptions);
app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDocs));

app.get('/', function (req, res) {
    res.send({
        message: 'express swagger doc'
    });
});

exports.app = functions.https.onRequest(app);