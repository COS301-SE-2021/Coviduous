let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let app = express();
//var serviceAccount = require("./permissions.json");
const authMiddleware = require('./authMiddleWare.js');

app.use(cors({ origin: true }));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
admin.initializeApp(); 


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

////////////////////////////////////////////////////////////////// Announcements //////////////////////////////////////////////////////
 /**
 * This function creates a new announcement via an HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  type: "GENERAL" || "EMERGENCY"
 *  message: string
 *  adminId: string
 *  companyId: string
 * The response object is sent back to the requester, containing the status code and a message.
 * res - HTTP status indicating whether the request was successful or not.
 */

app.post('/api/announcements',authMiddleware, async (req, res) =>  {
  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  console.log(reqJson);

  let fieldErrors = [];

  if (reqJson.type == null || reqJson.type === '') {
      fieldErrors.push({field: 'type', message: 'Type may not be empty'});
  }

  if (reqJson.type !== 'GENERAL' && reqJson.type !== 'EMERGENCY') {
      fieldErrors.push({field: 'type', message: 'Type must be either GENERAL or EMERGENCY'});
  }

  if (reqJson.message == null || reqJson.message === "") {
      fieldErrors.push({field: 'message', message: 'Message may not be empty'})
  }

  if (reqJson.adminId == null || reqJson.adminId === "") {
      fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'})
  }

  if (reqJson.companyId == null || reqJson.companyId === "") {
      fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
  }

  if (fieldErrors.length > 0) {
      console.log(fieldErrors);
      return res.status(400).send({
          message: '400 Bad Request: Incorrect fields',
          errors: fieldErrors
      });
  }

  let announcementId = "ANNOUNC-" + uuid.v4();
  let timestamp = new Date().today() + " " + new Date().timeNow();

  let announcementData = {
      announcementId: announcementId,
      type: reqJson.type,
      message: reqJson.message,
      timestamp: timestamp,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId
  }


  try {
      await database.collection('announcements').doc(announcementId)
        .create(announcementData);
        return res.status(200).send({
          message: 'Announcement successfully created',
          data: announcementData
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
 * This function gets announcements from a HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  companyId: string
 * The response object is sent back to the requester, containing the status code and a message and data.
 * res - HTTP status indicating whether the request was successful or not.
 */
app.post('/api/announcements/view',authMiddleware, async (req, res) =>  {

  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  console.log(reqJson);

  let fieldErrors = [];

  if (reqJson.companyId == null || reqJson.companyId === "") {
    fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
}

if (fieldErrors.length > 0) {
    console.log(fieldErrors);
    return res.status(400).send({
        message: '400 Bad Request: Incorrect fields',
        errors: fieldErrors
    });
}


  try {
    const document = database.collection('announcements');
    const snapshot = await document.get();
  
     let list = [];
  
    snapshot.forEach(doc => {
        let data = doc.data();
        list.push(data);
    });

    let filteredList=[]; 
    list.forEach(obj => {
     if(obj.companyId===reqJson.companyId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });
    return res.status(200).send({
      message: 'Successfully retrieved announcements',
      data: filteredList
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
 * This function deletes an announcement HTTP POST request.
 * req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  announcementId: string
 * The response object is sent back to the requester, containing the status code and a message and data.
 * res - HTTP status indicating whether the request was successful or not.
 */

app.post('/api/announcements/delete', authMiddleware,async (req, res) =>  {

  if (req == null || req.body == null) {
    return res.status(400).send({
        message: '400 Bad Request: Null request object',
    });
}

let reqJson;
try {
    reqJson = JSON.parse(req.body);
} catch (e) {
    reqJson = req.body;
}
console.log(reqJson);

let fieldErrors = [];

if (reqJson.announcementId == null || reqJson.announcementId === "") {
    fieldErrors.push({field: 'announcementId', message: 'Announcement ID may not be empty'});
}

if (fieldErrors.length > 0) {
  console.log(fieldErrors);
    return res.status(400).send({
        message: '400 Bad Request: Incorrect fields',
        errors: fieldErrors
    });
}

try {
    const document = database.collection('announcements').doc(reqJson.announcementId); // delete document based on announcementID
    await document.delete();
    return res.status(200).send({
        message: 'Announcement successfully deleted',
    });
} catch (error) {
    console.log("Error Occured While Trying To Delete The Following Object");
    console.log(error);
    return res.status(500).send({
        message: '500 Server Error: DB error',
        error: error
    });
}



});
 ////////////////////////////////////////////////////////////////// Announcements //////////////////////////////////////////////////////

///// Office /////
/**
 * This function creates a specified booking via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  bookingNumber: string
 *   deskNumber: string
 *   floorPlanNumber: string
 *   floorNumber: string
 *   roomNumber: string
 *   timestamp: string
 *   userId: string
 *   companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
 app.post('/api/office', authMiddleware, async (req, res) => {
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

    let dta ={
        summaryBookingId: summary,
        companyId: reqJson.companyId,
        numBookings: 1,
        month: month,
        year: year
    }

    try {
        await database.collection('bookings').doc(bookingNumber)
            .create(bookingData);

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

 exports.app = functions.https.onRequest(app);
