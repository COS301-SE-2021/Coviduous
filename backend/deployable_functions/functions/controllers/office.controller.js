let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let officeApp = express();
const authMiddleware = require('../authMiddleWare.js');

officeApp.use(cors({ origin: true }));
officeApp.use(express.urlencoded({ extended: true }));
officeApp.use(express.json());

// officeApp.use(authMiddleware);


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

/**
 * @swagger
 * /office:
 *   post:
 *     description: create a booking
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 officeApp.post('/api/office', async (req, res) => {
    let fieldErrors = [];

    if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (reqJson.deskNumber == null || reqJson.deskNumber === '') {
        fieldErrors.push({field: 'deskNumber', message: 'Desk number may not be empty'});
    }

    if (reqJson.floorPlanNumber == null || reqJson.floorPlanNumber === '') {
        fieldErrors.push({field: 'floorPlanNumber', message: 'Floor plan number may not be empty'});
    }

    if (reqJson.floorNumber == null || reqJson.floorNumber === '') {
        fieldErrors.push({field: 'floorNumber', message: 'Floor number may not be empty'});
    }

    if (reqJson.roomNumber == null || reqJson.roomNumber === '') {
        fieldErrors.push({field: 'roomNumber', message: 'Room number may not be empty'});
    }

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let bookingNumber = "BKN-" + uuid.v4();
    let summary = "SUM-"+uuid.v4();
    let timestamp = "Booking Placed On The : " + new Date().today() + " @ " + new Date().timeNow();
    let bookingData = { bookingNumber: bookingNumber, deskNumber: reqJson.deskNumber,
        floorPlanNumber: reqJson.floorPlanNumber, floorNumber: reqJson.floorNumber,
        roomNumber: reqJson.roomNumber, timestamp: timestamp, userId: reqJson.userId, companyId: reqJson.companyId
    }

    let time = new Date();
    let year = time.getFullYear();
    let month = time.getMonth()+1;

    let data = {
        summaryBookingId: summary,
        companyId: reqJson.companyId,
        numBookings: 1,
        month: month,
        year: year
    }

    try {
        await database.collection('bookings').doc(bookingNumber)
            .create(bookingData);

        //summary
        const document =  database.collection('summary-bookings').where("month","==",month);//entry should exist in db
        let snapshot = await document.get(); 

        let list = [];

        snapshot.forEach(doc => {
            let d = doc.data();
            //console.log(d)
            list.push(d);
        });
        
        for (const element of list) {
            if(data.month===element.month){
                c="checked";  
            }
        }

        if(c==="")
        {
            await database.collection('summary-bookings').doc(summary)
            .create(data); 
        }

        if(c==="checked")
        {
            const documents =  database.collection('summary-bookings').where("month","==",month);
            let s = await documents.get(); 
    
           let lists = [];
    
            s.forEach(doc => {
                let ds = doc.data();
                lists.push(ds);
            });
            
            let summaryId;
            let count;
            for (const elements of lists) {
                
                summaryId = elements.summaryBookingId;
                count =elements.numBookings;

            }

              
            let numBookings = parseInt(count) + 1;
            numBookings = numBookings.toString();
        
            
            const documented = database.collection('summary-bookings').doc(summaryId);
            await documented.update({ 
                numBookings:numBookings
             });
        } 

        return res.status(200).send({
            message: 'Office booking successfully created',
            data: bookingData
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

/**
 * @swagger
 * /office:
 *   delete:
 *     description: delete an office booking
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 officeApp.delete('/api/office', async (req, res) => {
    let fieldErrors = [];

    if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (reqJson.bookingNumber == null || reqJson.bookingNumber === '') {
        fieldErrors.push({field: 'bookingNumber', message: 'Booking number may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        //summary
        const documents = database.collection('bookings').where("bookingNumber","==",reqJson.bookingNumber);
        const snapshot = await documents.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(data)
            list.push(data);
        });

        let companyId;

        for (const element of list) {
         companyId = element.companyId;
         //console.log(companyId)
        }

         const doc =   database.collection('summary-bookings').where("companyId","==",companyId); 
         const snap = await doc.get(); 
         
        let lists = [];

        snap.forEach(docs => {
            let dat = docs.data();
            console.log(dat)
            lists.push(dat);
        });

        //console.log(lists)
      
        let numBooking;
        let summaryId;
        for (const element of lists) {
            summaryId = element.summaryBookingId,
            numBooking = element.numBookings;
           }
        
        console.log(numBooking);   
        let numBookings = parseInt(numBooking)-1;
        numBookings = numBookings.toString();   
        
        const documented = database.collection('summary-bookings').doc(summaryId);
        await documented.update({ 
            numBookings:numBookings
        }); 

        const document = database.collection('bookings').doc(reqJson.bookingNumber);
        await document.delete();

        return res.status(200).send({
            message: 'Office booking successfully deleted',
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

/**
 * @swagger
 * /office:
 *   post:
 *     description: retrieve all office bookings
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
officeApp.post('/api/office/view', async (req, res) => {
    let fieldErrors = [];

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('bookings').where("userId","==", reqJson.userId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved office bookings',
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

exports.office = functions.https.onRequest(officeApp);