//This file contains all the routes for the coviduous api
let router = require('express').Router();
let db = require("../config/office.firestore.database.js");

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default office API route'
    });
});

// Import office service
const officeService = require("../services/office/office.controller.js");
// Set the database you want to work with the test or production database
officeService.setDatabase(db);

// Office routes
// N.B. paths for a subsystem can all be the same
router.post('/office', officeService.createBooking);
router.post('/office/view', officeService.viewBookings);
router.delete('/office', officeService.deleteBooking);

// Export API routes
module.exports = router;