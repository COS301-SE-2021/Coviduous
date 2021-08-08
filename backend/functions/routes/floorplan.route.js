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
//router.get('/floorplan', floorplanService.viewAnnouncements);
//router.delete('/floorplan', floorplanService.deleteAnnouncement);

// Export API routes
module.exports = router;