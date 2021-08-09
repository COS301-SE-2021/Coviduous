let router = require('express').Router();

// Set default API response
router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'This is the default health API route'
    });
});

// Import health controller
const healthController = require("../services/health/health.controller.js");
// Import database
const devDatabase = require("../config/health.firestore.database.js");

// set database to use
healthController.setDatabase(devDatabase);

// Health routes
// N.B. paths for a subsystem can all be the same
router.post('/health/health-check', healthController.createHealthCheck);
router.get('/health/health-check', healthController.viewHealthChecks); // + based on userId
// router.post('/health/permission', healthController.createPermission);
// router.get('/health/permission', healthController.viewPermissions); // + based on userId
// router.post('/health/permission-request', healthController.createPermissionRequest);
// router.get('/health/permission-request', healthController.viewPermissionRequests); // + based on companyId

// Export API routes
module.exports = router;