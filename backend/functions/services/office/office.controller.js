let database;

// npm install uuid
const uuid = require("uuid");

/**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"
      +(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

/**
 * This function returns the current time in a specified format.
 * @returns {string} The current time as a string in the format HH:MM:SS.
 */
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"
       + ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"
       + ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

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
exports.createBooking = async (req, res) => {
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

    let result = await database.createBooking(dta, bookingData);

    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Office booking successfully created',
        data: bookingData
    });
};

/**
 * This function deletes a specified booking via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  bookingNumber: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteBooking = async (req, res) => {
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

    let result = await database.deleteBooking(reqJson.bookingNumber);

    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Booking successfully deleted',
    });
};


//get bookings using user ID
/**
 * This function views a specified booking via an HTTP VIEW request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  companyid: number
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.viewBookings = async (req, res) => {
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

    let filteredList = [];
    let bookings = await database.getBookings(reqJson.userId);
    bookings.forEach(obj => {
        if(obj.userId === reqJson.userId) {
            filteredList.push(obj);
        }
    });

    return res.status(200).send({
        message: 'Successfully retrieved bookings based on your user ID',
        data: filteredList
    });
};

/**
 * This function sets the database used by the office controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
exports.setDatabase = async(db) => {
    database = db;
}