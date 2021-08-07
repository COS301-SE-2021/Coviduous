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

// Announcement routes
// N.B. paths for a subsystem can all be the same
router.get('/announcement', announcementController.viewAnnouncements);
router.post('/announcement', announcementController.createAnnouncement);
router.delete('/announcement', announcementController.deleteAnnouncement);

// Export API routes
module.exports = router;