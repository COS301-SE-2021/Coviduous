let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default announcement API route'
    });
});

// Import announcement controller
const announcementController = require("../services/announcement/announcement.controller.js");
const announcementControllerMock = require("../services/announcement/announcement.controller.js");

// Import database
const devDatabase = require("../config/announcement.firestore.database.js");
const mockDatabase = require("../config/mock_database/announcement.firestore.mock.database");

// set database to use
announcementController.setDatabase(devDatabase);
announcementControllerMock.setDatabase(mockDatabase);

// Announcement routes
// N.B. paths for a subsystem can all be the same
router.get('/announcements', announcementController.viewAnnouncements);
router.post('/announcements', announcementController.createAnnouncement);
router.delete('/announcements', announcementController.deleteAnnouncement);


//Announcement routes mock
router.get('/mock/announcements', announcementControllerMock.viewAnnouncements);
router.post('/mock/announcements', announcementControllerMock.createAnnouncement);
router.delete('/mock/announcements', announcementControllerMock.deleteAnnouncement);


// Export API routes
module.exports = router;