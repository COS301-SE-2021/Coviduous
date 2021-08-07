const functions = require('firebase-functions');
const admin = require('firebase-admin'); 
//const express = require('express');
//const cors = require('cors');
//const app = express();
//var serviceAccount = require("../../permissions.json");

//app.use(cors({ origin: true }));

// admin.initializeApp({
//   credential: admin.credential.cert(serviceAccount),
//   databaseURL: "https://fir-api-9a206..firebaseio.com"
// });

const db = admin.firestore();

  
exports.createAnnouncement = async (req, res) => {
  try {
    await db.collection('announcements').doc(req.body.announcementId)
        .create(req.body); // .add - auto generates document id
    
    return res.status(200).send({
      message: 'Announcement successfully created',
      data: req.body
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};

exports.deleteAnnouncement = async (req, res) => {
  try {
    const document = db.collection('announcements').doc(req.body.announcementId); // delete document based on announcementID
    await document.delete();

    return res.status(200).send({
      message: 'Announcement successfully deleted'
    });
  } catch (error) {
    console.log(error);
    return res.status(500).send(error);
  }
};

exports.viewAnnouncements = async (req, res) => {
  try {
    const document = db.collection('announcements');
    const snapshot = await document.get();
    
    let list = [];
    
    snapshot.forEach(doc => {
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
};

