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

app.get('/hello-world', (req, res) => {
  return res.status(200).send('Hello World!');
});

app.post('/api/create', (req, res) => {
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

app.get('/api/announcement/view-announcements-admin', (req, res) => {
  (async () => {
      try {
        if(!req.body.adminId) {
          return res.status(400).send({
              message: "No adminID received"
          });
        }
          const document = db.collection('announcements').where('adminId', '==', 'test2');
          const snapshot = await document.get();
          let list = [];
          snapshot.forEach(doc => {
            let id = doc.id;
            let data = doc.data();
            list.push({id, ...data});
          });
          //let response = item.data();
          let announce=JSON.stringify(list);
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
