var config = require("./config/config.js");
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
var serviceAccount = require("./permissions.json");

app.use(cors({ origin: true }));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://fir-api-9a206..firebaseio.com"
}); 

app.get('/api', (req, res) => {
 return res.status(200).send('Connected to the coviduous api');
});


// STRUCTURE: Each subsystem has it's own route.js file, respective routes are defined there
// and each subsystem route.js file requires respective subsystem.controller.js file where functions are defined
let devDatabase = require("./config/firestore.database.js");
// Import routes
const announcementRoute = require("./routes/announcement.route.js")
const floorplanRoute = require("./routes/floorplan.route.js");

// app.use('/api', subsystem_nameRoute) - use /api/ path for each subsystem route
app.use('/api/', announcementRoute); // testing http would be '.../api/announcements' - see announcement.route.js file for routes
app.use('/api/',floorplanRoute)

exports.app = functions.https.onRequest(app);