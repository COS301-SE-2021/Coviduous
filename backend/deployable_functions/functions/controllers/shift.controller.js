let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let shiftApp = express();
//var serviceAccount = require("./permissions.json");
const authMiddleware = require('../authMiddleWare.js');

shiftApp.use(cors({ origin: true }));
shiftApp.use(express.urlencoded({ extended: true }));
shiftApp.use(express.json());
//admin.initializeApp(); 


let database = admin.firestore();
let uuid = require("uuid");

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

///////////////// functions /////////////////

///// shifts //////
shiftApp.get('/api/shift', async (req, res) => {
    try {
        const document = database.collection('shifts');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved shifts',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});



///// shift groups /////
shiftApp.post('/api/group/company-id', async (req, res) => {

    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'companyId may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('users').where("companyId","==",reqJson.companyId);
        const snapshot = await document.get();
 
        let list =[];
 
         snapshot.forEach(doc => {
             let data = doc.data();
             list.push(data);
         });

        return res.status(200).send({
            message: 'Successfully retrieved user emails',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});



exports.shift = functions.https.onRequest(shiftApp);