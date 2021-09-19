let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let notificationApp = express();
const authMiddleware = require('../authMiddleWare.js');

notificationApp.use(cors({ origin: true }));
notificationApp.use(express.urlencoded({ extended: true }));
notificationApp.use(express.json());

notificationApp.use(authMiddleware);

let database = admin.firestore();
let uuid = require("uuid");
 //////////////////////////////////////////////////////////////////General Functions ///////////////////////////////////////////////////
 /**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
  Date.prototype.today = function () { 
    return ((this.getDate() < 10)?"0":"") + this.getDate() + "/" +
        (((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
  }
  
  /**
  * This function returns the current time in a specified format.
  * @returns {string} The current time as a string in the format HH:MM:SS.
  */
  Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?"0":"") + this.getHours() + ":" +
        ((this.getMinutes() < 10)?"0":"") + this.getMinutes() + ":" +
        ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
  }
  
///////////////////////////////////////////////////////////////// GENERAL FUNCTIONS ////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////Notification//////////////////////////////////////////////////////////
/**
 * This function creates a new notification via an HTTP POST request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  userId: string
 *  userEmail: string
 *  subject: string
 *  timestamp: string
 *  message: string
 *  adminId: string
 *  companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res An HTTP status indicating whether the request was successful or not.
 */
/**
 * @swagger
 * /notifications:
 *   post:
 *     description: create a notification
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 notificationApp.post('/api/notifications', async (req, res) =>  {
    // try {
    // data validation
    let fieldErrors = [];
    
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);


    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (reqJson.userEmail == null || reqJson.userEmail === "") {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'});
    }

    if (reqJson.subject == null || reqJson.subject === "") {
        fieldErrors.push({field: 'subject', message: 'Subject may not be empty'});
    }

    if (reqJson.message == null || reqJson.message === "") {
        fieldErrors.push({field: 'message', message: 'Message may not be empty'});
    }

    if (reqJson.adminId == null || reqJson.adminId === "") {
        fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
    }

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let notificationId = "NTFN-" + uuid.v4();
    let timestamp = new Date().toISOString();

    
    let notificationData = {
        notificationId: notificationId,
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        subject: reqJson.subject,
        message: reqJson.message,
        timestamp: timestamp,
        adminId: reqJson.adminId,
        companyId: reqJson.companyId
    }

    try {
        await database.collection('notifications').doc(notificationId)
            .create(notificationData);
            return res.status(200).send({
            message: 'Notifications successfully created',
            data: notificationData
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }   
});

/**
* This function deletes a specified notification via an HTTP DELETE request.
* @param req The request object must exist and have the correct fields. It will be denied if not.
* The request object should contain the following:
*  notificationId: string
* @param res The response object is sent back to the requester, containing the status code and a message.
* @returns res - HTTP status indicating whether the request was successful or not.
*/
/**
 * @swagger
 * /notifications:
 *   delete:
 *     description: delete a notification
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
notificationApp.delete('/api/notifications', async (req, res) =>  {
    // try {0
    // data validation
    let fieldErrors = [];

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);

    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.notificationId == null || reqJson.notificationId === '') {
        fieldErrors.push({field: 'notificationId', message: 'Notification ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
            const document = database.collection('notifications').doc(reqJson.notificationId); // delete document based on notificationId
            await document.delete();
            return res.status(200).send({
            message: 'Notifications successfully created'
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});
   
/**
* This function retrieves all notifications via an HTTP GET request.
* @param req The request object may be null.
* @param res The response object is sent back to the requester, containing the status code and retrieved data.
* @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
*/
/**
 * @swagger
 * /notifications:
 *   post:
 *     description: retrieve notifications by user email
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
notificationApp.post('/api/notifications/user-email', async (req, res) =>  {
    // try {
    let fieldErrors = [];

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);

    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.userEmail == null || reqJson.userEmail === '') {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('notifications').where("userEmail", "==", reqJson.userEmail);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        return res.status(200).send({
            message: '',
            data: list
        });

    } catch (error) {
        console.log(error);
        return error;
    }    
});

/**
* This function retrieves all notifications via an HTTP GET request.
* @param req The request object may be null.
* @param res The response object is sent back to the requester, containing the status code and retrieved data.
* @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
*/
/**
 * @swagger
 * /notifications:
 *   get:
 *     description: Get all notifications
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
notificationApp.post('/api/notifications', async (req, res) =>  {
    try {
        const document = database.collection('notifications');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved notifications',
            data: list
        });
        
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching notifications."}); 
    }
});

exports.notification = functions.https.onRequest(notificationApp);