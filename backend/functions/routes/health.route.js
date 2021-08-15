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
//router.get('/health/health-check', healthController.viewHealthChecks);
//router.get('/health/health-check/userid', healthController.viewHealthCheckUserId);
//router.post('/health/permissions', healthController.createPermission);
router.get('/health/permissions', healthController.viewPermissions);
//router.get('/health/permissions/userid', healthController.viewPermissionsUserId);
router.post('/health/permissions/permission-request', healthController.createPermissionRequest);
router.get('/health/permissions/permission-request', healthController.viewPermissionRequests);
router.get('/health/permissions/permission-request/companyid', healthController.viewPermissionsRequestsCompanyId);
router.get('/health/contact-trace/group', healthController.viewGroup);
router.get('/health/contact-trace/shifts', healthController.viewShifts);
router.delete('/health/permissions',healthController.deletePermissionsPermissionId);
// Export API routes
module.exports = router;