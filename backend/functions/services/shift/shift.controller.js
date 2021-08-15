const Shift = require("../../models/shift.model");
const Group = require("../../models/group.model");
const uuid = require("uuid");

let db;

/**
 * This function sets the database used by the shift controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
exports.setDatabase = async (_db) => {
    db = _db;
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
 * This function create a specified shift via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *   date: string
 *   startTime: string
 *   endTime: string
 *   description: string
 *   adminId: string
 *   companyId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.createShift = async (req,res) => {
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

    if (reqJson.date == null || reqJson.date === '') {
        fieldErrors.push({field: 'date', message: 'Date may not be empty'});
    }

    if (reqJson.startTime == null || reqJson.startTime === '') {
        fieldErrors.push({field: 'startTime', message: 'Start time may not be empty'});
    }

    if (reqJson.endTime == null || reqJson.endTime === '') {
        fieldErrors.push({field: 'endTime', message: 'End time may not be empty'});
    }

    if (reqJson.description == null || reqJson.description === '') {
        fieldErrors.push({field: 'description', message: 'Description may not be empty'});
    }

    if (reqJson.adminId == null || reqJson.adminId === '') {
        fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
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

    let shiftID = "SHI-" + uuid.v4();
    let shift = new Shift(shiftID, reqJson.date, reqJson.startTime, reqJson.endTime,
        reqJson.description, reqJson.adminId, reqJson.companyId);
    let shiftData = { shiftID: shift.shiftID,date: shift.date,startTime: shift.startTime, endTime: shift.endTime,
        description: shift.description, adminId: shift.adminId, companyId: shift.companyId };

    let result = await db.createShift(shiftID, shiftData);

    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Shift successfully created',
        data: shiftData
    });
};

exports.createGroup = async (req, res) => {
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

    if (reqJson.groupName == null || reqJson.groupName === '') {
        fieldErrors.push({field: 'groupName', message: 'Group name may not be empty'});
    }

    if (reqJson.userEmails == null || reqJson.userEmails === '') {
        fieldErrors.push({field: 'userEmails', message: 'There must be at least one user email'});
    }

    if (reqJson.shiftNumber == null || reqJson.shiftNumber === '') {
        fieldErrors.push({field: 'shiftNumber', message: 'Shift number may not be empty'});
    }

    if (reqJson.adminId == null || reqJson.adminId === '') {
        fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
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

    
    let groupId = "GRP-" + uuid.v4();
    let group = new Group(groupId, reqJson.groupName, reqJson.userEmails, reqJson.shiftNumber, reqJson.adminId);
    let groupData = { groupId: group.groupNumber, groupName: group.groupName,
        userEmails: group.userEmails, shiftNumber: group.shiftNumber, adminId: group.adminId };

    let result = await db.createGroup(groupId, groupData);

        
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Group successfully created',
        data: groupData
    });
}

/**
 * This function deletes a specified shift via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  shiftId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteShift = async (req, res) => {
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

    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftID == null || reqJson.shiftID === '') {
        fieldErrors.push({field: 'shiftID', message: 'Shift ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    if (await db.deleteShift(reqJson.shiftID) == true) {
        return res.status(200).send({
            message: "Shift successfully deleted"
        });
    } else {
        return res.status(500).send({message: "500 server error."});
    }
};

/**
 * This function updates a specified shift via an HTTP UPDATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  shiftId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.updateShift = async (req, res) => {
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

       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftID == null || reqJson.shiftID === '') {
        fieldErrors.push({field: 'shiftID', message: 'Shift ID may not be empty'});
    }
    if(reqJson.endTime == null || reqJson.endTime===''){
        fieldErrors.push({field: 'endTime', message: 'endTime may not be empty'});
    }
    if(reqJson.startTime == null || reqJson.startTime===''){
        fieldErrors.push({field: 'startTime', message: 'startTime may not be empty'});
    }

   

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
  
    if (await db.updateShift(reqJson.shiftID, reqJson) == true) {
      return res.status(200).send({
        data: req.body
      });
    } else {
      return res.status(500).send({message: "Some error occurred while updating shifts."});
    }
};

/**
 * This function retrieves all shifts via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.viewShifts = async (req, res) => {
    let viewShifts = await db.viewShifts();
      
    if (viewShifts != null) {
      return res.status(200).send({
        message: 'Successfully retrieved shifts',
        data: viewShifts
      });
    } else {
      return res.status(500).send({message: "Some error occurred while fetching shifts."});
    }
};
/**
 * This function retrieves all groups via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */

 exports.getGroup = async (req, res) => {
    let getGroups = await db.getGroup();
      
    if (getGroups != null) {
      return res.status(200).send({
        message: 'Successfully retrieved groups',
        data: getGroups
      });
    } else {
      return res.status(500).send({message: "Some error occurred while fetching shifts."});
    }
};