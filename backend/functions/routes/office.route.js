//This file contains all the routes for the coviduous api
let router = require('express').Router();
let db = require("../config/office.firestore.database.js");
let database = require("../config/mock_database/office.firestore.mock.database")

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default office API route'
    });
});

// Import office service
const officeService = require("../services/office/office.controller.js");
//const officeServiceMock = require("../services/office/office.controller.js");

// Set the database you want to work with the test or production database
officeService.setDatabase(db);
//officeServiceMock.setDatabase(database);

// Office routes
// N.B. paths for a subsystem can all be the same
/**
 * @swagger
 * /office:
 *   post:
 *     description: create a booking
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/office', officeService.createBooking);
/**
 * @swagger
 * /office:
 *   post:
 *     description: retrieve all office bookings
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/office/view', officeService.viewBookings);
/**
 * @swagger
 * /office:
 *   delete:
 *     description: delete an office booking
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.delete('/office', officeService.deleteBooking);

// Office routes Mock 
// N.B. paths for a subsystem can all be the same
//router.post('/mock/office', officeServiceMock.createBooking);
//router.post('/mock/office/view', officeServiceMock.viewBookings);
//router.delete('/mock/office', officeServiceMock.deleteBooking);

// Export API routes
module.exports = router;