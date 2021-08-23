const Notification = require("../../models/notification.model");
const uuid = require("uuid"); // npm install uuid
var nodemailer = require('nodemailer');

let database;

exports.setDatabase = async (db) => {
    database = db;
}

exports.verifyCredentials = async (adminId, companyId) => {
    let isCredentialsValid = true;
    
    return isCredentialsValid;  
}

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
exports.createNotification = async (req, res) => {
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

    if (await this.verifyCredentials(reqJson.adminId, reqJson.companyId) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

    let notificationId = "NTFN-" + uuid.v4();
    let timestamp = new Date().toISOString();

    let notificationObj = new Notification(notificationId, reqJson.userId, reqJson.userEmail,
        reqJson.subject, reqJson.message, timestamp, reqJson.adminId, reqJson.companyId);

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

    if (await database.createNotification(notificationData.notificationId, notificationData) == true)
    {
        return res.status(200).send({
        message: 'Notification successfully created',
        data: notificationData
        });
    }
    else
    {
        return res.status(500).send({message: "500 server error."});
    }
};

/**
 * This function deletes a specified notification via an HTTP DELETE request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 *  notificationId: string
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteNotification = async (req, res) => {
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

    if (await database.deleteNotification(req.body.notificationId) == true)
    {
        return res.status(200).send({
            message: 'Notification successfully deleted',
        });
    }
    else
    {
        return res.status(500).send({message: "500 server error."});
    }
};

/**
 * This function retrieves all notifications via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.viewNotifications = async (req, res) => {
        let notifications = await database.viewNotifications();


        if (notifications != null)
        {
            return res.status(200).send({
                message: 'Successfully retrieved notifications',
                data: notifications
            });      
        }
        else
        {
            return res.status(500).send({message: "Some error occurred while fetching notifications."});
        }
};

/**
 * This function retrieves all notifications based on user email via an HTTP GET request.
 * @param req The request object may not be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.viewNotificationsUserEmail = async (req, res) => {
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

        let notifications = await database.viewNotificationsUserEmail(reqJson.userEmail);

        if (notifications != null)
        {
            return res.status(200).send({
                message: 'Successfully retrieved notifications',
                data: notifications
            });      
        }
        else
        {
            return res.status(500).send({message: "Some error occurred while fetching notifications."});
        }
    // } catch (error) {
    //     console.log(error);
    //     return res.status(500).send({
    //         message: error.message || "Some error occurred while fetching notifications."
    //     });
    // }
};


/**
 * This function sends an email to a user using the users email address
 * The function is used as an internal service to other functions 
 * @param req The request object may not be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
 exports.sendUserEmail = async (receiver,subject,message) => {
    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'capslock.cos301@gmail.com',
          pass: 'Coviduous.COS301'
        }
      });
      
      var mailOptions = {
        from: 'capslock.cos301@gmail.com',
        to: receiver,
        subject: subject,
        text: message
      };
      
      transporter.sendMail(mailOptions, function(error, info){
        if (error) {
          console.log(error);
        } else {
          console.log('Email sent: ' + info.response);
          return true;
        }
      }); 
 };