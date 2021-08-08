//This file contains all the routes for the coviduous api
let router = require('express').Router();
let devDatabase = require("../config/office.firestore.database.js");
let db=new devDatabase();
let testDatabase;

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
officeService.setDatabse(db);

// Floorplan routes
// N.B. paths for a subsystem can all be the same
router.post('/office', officeService.createBooking);
router.get('/office', officeService.viewBookings);
router.delete('/office', officeService.deleteBooking);


// Export API routes
module.exports = router;