//This file contains all the routes for the coviduous api
let router = require('express').Router();
let devDatabase = require("../config/floorplan.firestore.database.js");
let db=new devDatabase();
let testDatabase;

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default floorplan API route'
    });
});

// Import floorplan service
const floorplanService = require("../services/floorplan/floorplan.controller.js");
// Set the database you want to work with the test or production database
floorplanService.setDatabse(db);

// Floorplan routes
// N.B. paths for a subsystem can all be the same
router.post('/floorplan', floorplanService.createFloorPlan);
router.post('/floorplan/floor', floorplanService.createFloor);
router.post('/floorplan/room', floorplanService.createRoom);
//when we get back our floorplans we query the database based on the companyId.
//floorplans returned are based on the companyId
router.get('/floorplan', floorplanService.viewFloorPlans);
// we retrieve our floors based on the floorplanNumber
router.get('/floorplan/floors', floorplanService.viewFloors);
// we retrieve our roomss based on the floorNumber
router.get('/floorplan/floors/rooms', floorplanService.viewRooms);
//router.delete('/floorplan', floorplanService.deleteAnnouncement);

// Export API routes
module.exports = router;