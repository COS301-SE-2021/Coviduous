let router = require('express').Router();

//default response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default notification API route'
    });
});

//import notification controller
const notificationController = require("../services/notification/notification.controller.js");
const devDatabase = require("../config/notification.firestore.database.js");

//setting database
notificationController.setDatabase(devDatabase);

//notification routes
router.get('/notification', notificationController.viewNotifications);
router.post('/notification', notificationController.createNotification);
router.delete('/notification', notificationController.deleteNotification);

// Export API routes
module.exports = router;

