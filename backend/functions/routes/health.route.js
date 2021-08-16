// Import health controller
const healthController = require("../services/health/health.controller.js");
// Import database
const devDatabase = require("../config/health.firestore.database.js");
const devDatabase2 = require("../config/notification.firestore.database.js");

// set database to use
healthController.setDatabase(devDatabase);
healthController.setNotificationDatabase(devDatabase2);

// Health routes
// N.B. paths for a subsystem can all be the same
router.post('/health/health-check', healthController.createHealthCheck);
router.post('/health/report-infection', healthController.reportInfection);
router.get('/health/permissions', healthController.viewPermissions);
router.delete('/health/permissions',healthController.deletePermissionRequest);

router.post('/health/permissions/permission-request', healthController.createPermissionRequest);
router.post('/health/permissions/permission-request/grant', healthController.grantPermission);
router.get('/health/permissions/permission-request', healthController.viewPermissionsRequestsCompanyId);
router.get('/health/contact-trace/group', healthController.viewGroup);
router.get('/health/contact-trace/shifts', healthController.viewShifts);
router.get('/health/contact-trace/notify-group', healthController.notifyGroup);

// Export API routes
module.exports = router;