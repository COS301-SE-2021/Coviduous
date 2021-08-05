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
// });

const db = admin.firestore();

exports.createNotification = async (req, res) => {
//(async () => {
    try {
        await db.collection('notifications').doc(req.body.notificationID)
            .create(req.body); // .add - auto generates document id
        
        return res.status(200).send({
        message: 'Notification successfully created',
        data: req.body
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
    //});
};

exports.deleteNotification = async (req, res) => {
//(async () => {
    try {
        const document = db.collection('notifications').doc(req.body.notificationID); // delete based on notificationID
        await document.delete();
        return res.status(200).send({
            message: 'Notification successfully deleted'
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
    //})
};

exports.viewNotifications = async (req, res) => {
//(async () => {
    try {
        const document = db.collection('notifications'); //.where("field", "==", req.body.field); // get notification documents based on 'field'
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            //let id = doc.id;
            let data = doc.data();
            list.push(data);
        });

        let notifications = list;
        
        return res.json({
            message: 'Successfully retrieved notifications',
            data: notifications 
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: err.message || "Some error occurred while fetching notifications."
        });
    }
    //});
};