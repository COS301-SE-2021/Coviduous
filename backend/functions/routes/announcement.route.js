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
const devDatabase = require("../config/announcement.firestore.database.js");

// set database to use
announcementController.setDatabase(devDatabase);

// Announcement routes
// N.B. paths for a subsystem can all be the same
router.get('/announcements', announcementController.viewAnnouncements);
router.post('/announcements', announcementController.createAnnouncement);
router.delete('/announcements', announcementController.deleteAnnouncement);

// Export API routes
module.exports = router;