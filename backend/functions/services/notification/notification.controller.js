const Notification = require("../../models/notification.model");
const uuid = require("uuid"); // npm install uuid

let database;

exports.setDatabase = async (db) => {
    database = db;
}

exports.verifyCredentials = async (adminId, companyId) => {
    let isCredentialsValid = true;
    
    return isCredentialsValid;  
}

// doc
exports.createNotification = async (req, res) => {
    // try {
        let reqJson = JSON.parse(req.body);
        console.log(reqJson);

        // data validation
        let fieldErrors = [];

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

        if (reqJson.timestamp == null || reqJson.timestamp === "") {
            fieldErrors.push({field: 'timestamp', message: 'Timestamp may not be empty'});
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
          notificationId: notificationObj.notificationId,
          userId: notificationObj.userId,
          userEmail: notificationObj.userEmail,
          subject: notificationObj.subject,
          message: notificationObj.message,
          timestamp: notificationObj.timestamp,
          adminId: notificationObj.adminId,
          companyId: notificationObj.companyId
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
            return res.status(500).send('500 Server Error');
        }
    //   } catch (error) {
    //       console.log(error);
    //       return res.status(500).send(error);
    //   }
};

exports.deleteNotification = async (req, res) => {
    // try {
        // data validation
        let fieldErrors = [];

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
            return res.status(500).send('500 Server Error');
        }
    // } catch (error) {
    //     console.log(error);
    //     return res.status(500).send(error);
    // }
};

exports.viewNotifications = async (req, res) => {
    // try {
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
            return res.status(500).send("Some error occurred while fetching notifications.");
        }
    // } catch (error) {
    //     console.log(error);
    //     return res.status(500).send({
    //         message: error.message || "Some error occurred while fetching notifications."
    //     });
    // }
};

exports.viewNotificationsUserEmail = async (req, res) => {
    // try {
        let fieldErrors = [];

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

        let reqJson = JSON.parse(req.body);
        console.log(reqJson);

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
            return res.status(500).send("Some error occurred while fetching notifications.");
        }
    // } catch (error) {
    //     console.log(error);
    //     return res.status(500).send({
    //         message: error.message || "Some error occurred while fetching notifications."
    //     });
    // }
};