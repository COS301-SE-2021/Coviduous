const functions = require("firebase-functions");
const admin = require('firebase-admin');
 const express = require('express');
 const cors = require('cors');
 const app = express();

 app.use(cors({ origin: true }));

 app.get('/api', (req, res) => {
   return res.status(200).send('Connected to the coviduous api');
 });

// // Import controllers
 const floorPlanController = require("./routes/floorplan/floorplan.service.js");

 //subroutes
 app.post('/api/floorplan/create-floorplan', floorPlanController.createFloorPlan);
 exports.app = functions.https.onRequest(app);

// app.post('/api/announcement/create-announcement', announcementController.createAnnouncement);
// app.delete('/api/announcement/delete-announcement', announcementController.deleteAnnouncement);
// app.get('/api/announcement/view-announcements', announcementController.viewAnnouncements);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
 /*exports.helloWorld = functions.https.onRequest((request, response) => {
   functions.logger.info("Hello logs!", {structuredData: true});
   response.send("Hello from Firebase!");
 });

 exports.api = functions.https.onRequest(async (request, response) => {
     switch (request.method) {
         case 'GET':
             //const res= await axios.get()
             response.send("GET REQUEST!");
             break;
        case 'POST':
             response.send("POST REQUEST!");
             break;
        case 'DELETE':
             response.send("DELETE REQUEST!");
             break;
        case 'PUT':
             response.send("PUT REQUEST!");
             break;
     
         default:
            response.send("CANNOT HANDLE THE REQUEST!");
             break;
     }
   
 });

//AUTH FUNCTIONS EVENTS
exports.userAdded = functions.auth.user().onCreate(user =>{
   console.log("User created");
   return Promise.resolve();
 });

 exports.userDeleted = functions.auth.user().onDelete(user =>{
   console.log("User deleted");
   return Promise.resolve();
 });

exports.testFunction = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", {structuredData: true});
    response.send("Hello from test function!");
});

// const functions = require('firebase-functions');
// const admin = require('firebase-admin');
// const express = require('express');
// const cors = require('cors');
// const app = express();
// var serviceAccount = require("./permissions.json");

// app.use(cors({ origin: true }));

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://fir-api-9a206..firebaseio.com"
// });

// // const db = admin.firestore();

// app.get('/api', (req, res) => {
//   return res.status(200).send('Connected to the coviduous api');
// });

// // Import controllers
// const announcementController = require("./components/announcement/announcement.controller.js");
// const notificationController = require("./components/notification/notification.controller.js");

// app.post('/api/announcement/create-announcement', announcementController.createAnnouncement);
// app.delete('/api/announcement/delete-announcement', announcementController.deleteAnnouncement);
// app.get('/api/announcement/view-announcements', announcementController.viewAnnouncements);

// app.post('/api/notification/create-notification', notificationController.createNotification);
// app.delete('/api/notification/delete-notification', notificationController.deleteNotification);
// app.get('/api/notification/view-notifications', notificationController.viewNotifications);

// exports.app = functions.https.onRequest(app);

*/