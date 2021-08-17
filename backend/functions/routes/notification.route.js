let router = require('express').Router();

//default response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default notification API route'
    });
});

// import notification controller
const notificationController= require("../services/notification/notification.controller.js");
const notificationMockService=require("../services/notification/notification.controller.js");
// import database
const devDatabase = require("../config/notification.firestore.database.js");
const mockDatabase = require("../config/mock_database/notification.firestore.mock.database.js");

// setting database
notificationController.setDatabase(devDatabase);
notificationMockService.setDatabase(mockDatabase);
//Notification routes for mock testing
router.post('/mock/notifications', notificationMockService.createNotification);
router.post('/mock/notifications/user-email', notificationMockService.viewNotificationsUserEmail);
router.delete('/mock/notifications', notificationMockService.deleteNotification);

// Notification routes
router.get('/notifications', notificationController.viewNotifications);
router.post('/notifications/user-email', notificationController.viewNotificationsUserEmail);
router.post('/notifications', notificationController.createNotification);
router.delete('/notifications', notificationController.deleteNotification);

// Export API routes
module.exports = router;

