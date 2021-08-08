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
//when we get back our floorplans we query the database based on the companyId.
//floorplans returned are based on the companyId
//router.get('/floorplan', floorplanService.viewFloorPlans);
// we retrieve our floors based on the floorplanNumber
//router.get('/floorplan/floors', floorplanService.viewFloors);
// we retrieve our roomss based on the floorNumber
//router.get('/floorplan/floors/rooms', floorplanService.viewRooms);
//router.put('/floorplan/room',floorplanService.updateRoom);
//router.delete('/floorplan', floorplanService.deleteAnnouncement);

// Export API routes
module.exports = router;