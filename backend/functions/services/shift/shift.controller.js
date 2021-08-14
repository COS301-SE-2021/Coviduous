const Shift = require("../../models/shift.model");
const uuid = require("uuid");

let db;

exports.setDatabase = async(_db) => {
    db =_db;
};

/**
 * This function create a specified shift via an HTTP CREATE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  shiftId: string
 *   startTime: Date
 *   endTime: Date
 *   description: string
 *   groupNo: int
 *   adminId: String
 *   companyId: String
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.createShift = async (req,res) => {
    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if(reqJson.shiftID != null && reqJson.date != null && reqJson.startTime != null && reqJson.endTime != null &&
        reqJson.description != null && reqJson.groupNo != null && reqJson.adminId != null && reqJson.companyId != null) {

        let shiftID = "SHI-" + uuid.v4();
        let shift = new Shift(shiftID, reqJson.date, reqJson.startTime, reqJson.endTime,
            reqJson.description, reqJson.groupNo, reqJson.adminId, reqJson.companyId);
        let shiftData = { shiftID: shift.shiftID, startTime: shift.startTime, endTime: shift.endTime,
            description: shift.description, groupNo: shift.groupNo, adminId: shift.adminId, companyId: shift.companyId }

        if(await db.createShift(shiftID,shiftData)==true){
            return res.status(200).send({
                data: req.body
            });
        }
        else {
            return res.status(500).send({message: "500 server error."});
        }
    }

};

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