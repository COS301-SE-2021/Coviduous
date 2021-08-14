const Announcement = require("../../models/announcement.model");
const uuid = require("uuid"); // npm install uuid

let database;

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

/**
 * This function sets the database used by the announcement controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
exports.setDatabase = async (db) => {
    database = db;
}

/**
 * Verifies the request token provided to it to ensure only authorized admins can make announcements.
 * @param token A JWT token.
 * @returns {Promise<boolean>} Returns true if the token is valid and false if it is not.
 */
exports.verifyRequestToken = async (token) => {
    let isTokenValid = true;
    return isTokenValid;
}

/**
 * Verifies if an administrator of a company's credentials are valid.
 * @param adminId The administrator's ID.
 * @param companyId The company's ID.
 * @returns {Promise<boolean>} Returns true if the credentials are valid and false if they are not.
 */
exports.verifyCredentials = async (adminId, companyId) => {
    let isCredentialsValid = true;
    return isCredentialsValid;
}

/**
 * This function creates a new announcement via an HTTP POST request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  type: "GENERAL" || "EMERGENCY"
 *  message: string
 *  adminId: string
 *  companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.createAnnouncement = async (req, res) => {
    let token = '';

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
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
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    if (await this.verifyCredentials(reqJson.adminId, reqJson.companyId) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    let announcementId = "ANNOUNC-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let announcementData = {
        announcementId: announcementId,
        type: reqJson.type,
        message: reqJson.message,
        timestamp: timestamp,
        adminId: reqJson.adminId,
        companyId: reqJson.companyId
    }

    let result = await database.createAnnouncement(announcementData.announcementId, announcementData);
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
       message: 'Announcement successfully created',
       data: announcementData
    });
};

/**
 * This function deletes a specified announcement via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  announcementId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteAnnouncement = async (req, res) => {
    let token = '';

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
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

    let fieldErrors = [];

    if (reqJson.announcementId == null || reqJson.announcementId === "") {
        fieldErrors.push({field: 'announcementId', message: 'Announcement ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let result = await database.deleteAnnouncement(reqJson.announcementId);
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Announcement successfully deleted',
    });
};

/**
 * This function retrieves all announcements via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.viewAnnouncements = async (req, res) => {
    let token = '';

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
            data: null
        });
    }

    let result = await database.viewAnnouncements();
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
            data: null
        });
    }

    return res.status(200).send({
        message: 'Successfully retrieved announcements',
        data: result
    });
};