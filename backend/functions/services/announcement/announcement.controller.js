const Announcement = require("../../models/announcement.model");
const uuid = require("uuid"); // npm install uuid

let database;
// For todays date;
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"+(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

// For the time now
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

exports.setDatabase = async (db) => {
  database = db;
}

exports.containsRequiredFieldsForCreateAnnouncement = async (req) => {
   let hasRequiredFields=false;
   if(req.type!=null && req.type!="" && req.message!=null && req.message!="" &&
       req.adminId!=null && req.adminId!="" && req.companyId!=null && req.companyId!="")
   {
     //check if the type is of the correct type "GENERAL OR EMERGENCY"
      if(req.type==="GENERAL"||req.type==="EMERGENCY")
      {
        hasRequiredFields=true;
      }
   }

   return hasRequiredFields;
}

exports.verifyRequestToken = async () => {
  let isTokenValid=true;
  
   return isTokenValid;
  
}

exports.verifyCredentials = async (adminId,companyId) => {
  let isCredentialsValid=true;
  
   return isCredentialsValid;
  
}

/**
 * This function creates a new announcement via an HTTP POST request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  type: "GENERAL" || "EMERGENCY"
 *  message: String
 *  adminId: String
 *  companyId: String
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res An HTTP status indicating whether the request was successful or not.
 */
exports.createAnnouncement = async (req, res) => {
    if (await this.verifyRequestToken() === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    if(req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson = JSON.parse(req.body);
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.type == null || reqJson.type === '') {
        fieldErrors.push({field: 'type', message: 'Type may not be empty'});
    }

    if (reqJson.type !== 'GENERAL' || reqJson.type !== 'EMERGENCY') {
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
    });
};

/**
 * This function deletes a new announcement via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  announcementId: String
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res An HTTP status indicating whether the request was successful or not.
 */
exports.deleteAnnouncement = async (req, res) => {
    if (await this.verifyRequestToken() === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    if(req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson = JSON.parse(req.body);
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

exports.viewAnnouncements = async (req, res) => {
  try {
      let announcements = await database.viewAnnouncements();
      
      return res.status(200).send({
        message: 'Successfully retrieved announcements',
        data: announcements
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching announcements."
      });
  }
};