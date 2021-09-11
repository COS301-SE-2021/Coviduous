require('dotenv').config(); //Dependency for environment variables

var config = require("./config/config.js");
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
var serviceAccount = require("./permissions.json");

const swaggerJSDoc = require('swagger-jsdoc');
const swaggerUI = require('swagger-ui-express');

app.use(cors({ origin: true }));
app.use(express.urlencoded({ extended: true }));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: process.env.FirebaseDatabaseURL //Requires .env file to be in backend/functions
}); 

//Swagger Configuration
const swaggerOptions = {
  swaggerDefinition: {
      info: {
          title:'Coviduous API',
          version:'1.0.0'
      }
  },
  apis:['./routes/*.js'],
  servers: ['http://localhost:5002/coviduous-api/us-central1/app']
}

const swaggerDocs = swaggerJSDoc(swaggerOptions);
app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(swaggerDocs));

app.get('/api', (req, res) => {
  return res.status(200).send('Connected to the coviduous api');
});

// STRUCTURE: Each subsystem has it's own route.js file, respective routes are defined there
// and each subsystem route.js file requires respective subsystem.controller.js file where functions are defined

// Import routes
const announcementRoute = require("./routes/announcement.route.js")
const notificationRoute = require("./routes/notification.route.js")
const floorplanRoute = require("./routes/floorplan.route.js");
const userRoute = require("./routes/user.route.js");
const shiftRoute = require("./routes/shift.route.js");
const officeRoute = require("./routes/office.route.js");
const healthRoute = require("./routes/health.route.js");
const reportingRoute = require("./routes/reporting.route.js");

// app.use('/api', subsystem_nameRoute) - use '/api/' path for each subsystem route
app.use('/api/', announcementRoute);
app.use('/api/', notificationRoute);
app.use('/api/', floorplanRoute);
app.use('/api/', userRoute);
app.use('/api/', shiftRoute);
app.use('/api/', officeRoute);
app.use('/api/', healthRoute);
app.use('/api/', reportingRoute);

exports.app = functions.https.onRequest(app);