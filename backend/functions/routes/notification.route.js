let router = require('express').Router();
const authMiddleware = require('../authMiddleware.js');

//default response
router.get('/notifications/rest', authMiddleware,function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default notification API route'
    });
});

// import notification controller
const notificationController = require("../services/notification/notification.controller.js");
//const notificationMockService = require("../services/notification/notification.controller.js");
// import database
const devDatabase = require("../config/notification.firestore.database.js");
//const mockDatabase = require("../config/mock_database/notification.firestore.mock.database.js");

// setting database
notificationController.setDatabase(devDatabase);
//notificationMockService.setDatabase(mockDatabase);

//Notification routes for mock testing
//router.post('/mock/notifications', notificationMockService.createNotification);
//router.post('/mock/notifications/user-email', notificationMockService.viewNotificationsUserEmail);
//router.delete('/mock/notifications', notificationMockService.deleteNotification);

// Notification routes
/**
 * @swagger
 * /notifications:
 *   get:
 *     description: Get all notifications
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.get('/notifications', notificationController.viewNotifications);
/**
 * @swagger
 * /notifications:
 *   post:
 *     description: retrieve notifications by user email
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/notifications/user-email', notificationController.viewNotificationsUserEmail);
/**
 * @swagger
 * /notifications:
 *   post:
 *     description: create a notification
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/notifications', notificationController.createNotification);
/**
 * @swagger
 * /notifications:
 *   delete:
 *     description: delete a notification
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.delete('/notifications', notificationController.deleteNotification);

// Export API routes
module.exports = router;

