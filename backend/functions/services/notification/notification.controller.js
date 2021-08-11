const Notification = require("../../models/notification.model");
const uuid = require("uuid"); // npm install uuid

let database;

exports.setDatabase = async (db) => {
    database = db;
}

exports.createNotification = async (req, res) => {
    try {
        let notificationId = "NTFN-" + uuid.v4();
        let timestamp = new Date().toISOString();
    
        let notificationObj = new Notification(notificationId, req.body.userId, req.body.userEmail,
            req.body.subject, req.body.message, timestamp, req.body.adminId, req.body.companyId);
    
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
      } catch (error) {
          console.log(error);
          return res.status(500).send(error);
      }
};

exports.deleteNotification = async (req, res) => {
    try {
        if (await database.deleteNotification(req.body.notificationId) == true)
        {
            return res.status(200).send({
                message: 'Notification successfully deleted',
            });
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
};

exports.viewNotifications = async (req, res) => {
    try {
        let notifications = await database.viewNotifications();
        return res.status(200).send({
            message: 'Successfully retrieved notifications',
            data: notifications
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: error.message || "Some error occurred while fetching notifications."
        });
    }
};

exports.viewNotificationsUserEmail = async (req, res) => {
    try {
        let notifications = await database.viewNotificationsUserEmail(req.body.userEmail);
        return res.status(200).send({
            message: 'Successfully retrieved notifications',
            data: notifications
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
            message: error.message || "Some error occurred while fetching notifications."
        });
    }
};