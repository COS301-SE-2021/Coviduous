const functions = require('firebase-functions');
const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors({ origin: true }));
var serviceAccount = require("./permissions.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://fir-api-9a206..firebaseio.com"
});
const db = admin.firestore();

app.get('/api', (req, res) => {
  return res.status(200).send('Connected to the frontend api');
});

app.delete('/api/announcement/delete-announcement', (req, res) => {
  (async () => {
      try {
          const document = db.collection('announcements').doc(req.body.announcementId);
          await document.delete();
          return res.status(200).send();
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
      })();
  })

app.post('/api/announcement/create-announcement', (req, res) => {
  (async () => {
      try {
        await db.collection('announcements').doc('/' + req.body.id + '/')
            .create({announcents: req.body});
        return res.status(200).send();
      } catch (error) {
        console.log(error);
        return res.status(500).send(error);
      }
    })();
});

app.get('/api/announcement/view-announcements', (req, res) => {
  (async () => {
      try {
        if(!req.body.adminId) {
          return res.status(400).send({
              message: "No adminID received"
          });
        }
          const document = db.collection('announcements');
          const snapshot = await document.get();
          
          let list = [];
          snapshot.forEach(doc => {
            let id = doc.id;
            let data = doc.data();
            list.push({data});
          });
          //let response = item.data();
          let announce=list;
          return res.json({
            status: 200,
            message: 'Announcements successfully fetched',
            data: announce
        });
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: err.message || "Some error occurred while fetching announcements."
        });
      }
      })();
  });

 

exports.app = functions.https.onRequest(app);
