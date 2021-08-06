let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default announcement api route'
    });
});

// Import announcement controller
const announcementController = require("../components/announcement/announcement.controller.js");

// Announcement routes
router.get('/view-announcements', announcementController.viewAnnouncements);
router.post('/create-announcement', announcementController.createAnnouncement);
router.delete('/delete-announcement', announcementController.deleteAnnouncement);

// Export API routes
module.exports = router;