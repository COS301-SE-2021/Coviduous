const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
//const app = express();
var serviceAccount = require("../../permissions.json");

//app.use(cors({ origin: true }));

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://fir-api-9a206..firebaseio.com"
//});


const db = admin.firestore();

  
exports.createAnnouncement = async (req, res) => {
  //(async () => {
      try {
        await db.collection('announcements').doc(req.body.announcementId)
            .create(req.body); // .add - auto generates document id
        
        return res.status(200).send({
          message: 'Announcements successfully created',
          data: req.body
        });
      } catch (error) {
        console.log(error);
        return res.status(500).send(error);
      }
    //});
};

exports.deleteAnnouncement = async (req, res) => {
  //(async () => {
      try {
          const document = db.collection('announcements').doc(req.body.announcementId); // delete document based on announcementID
          //const document = db.collection('floorplans').where("companyID", "==", req.body.companyID); // get document based on companyID
          await document.delete();

          return res.status(200).send({
            message: 'Announcement successfully deleted'
          });
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
    //});
};
  
exports.viewAnnouncements = async (req, res) => {
  //(async () => {
      try {
          const document = db.collection('announcements');
          const snapshot = await document.get();
          
          let list = [];
          
          snapshot.forEach(doc => {
            //let id = doc.id;
            let data = doc.data();
            list.push(data);
          });

          let announcements = list;
          
          return res.json({
            message: 'Successfully retrieved announcements',
            data: announcements 
          });
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: err.message || "Some error occurred while fetching announcements."
        });
      }
    //});
};
class announcements {
    constructor() {
        console.log("First Unit test");
    }
    add(var1, var2) {
        let results;
        results = var1 + var2;
        return results;
    }
}
module.exports = announcements;
