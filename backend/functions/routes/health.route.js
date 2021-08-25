// Import health controller
const healthController = require("../services/health/health.controller.js");
let router = require('express').Router();
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
router.post('/health/Covid19VaccineConfirmation', healthController.uploadCovid19VaccineConfirmation);
router.post('/health/Covid19TestResults', healthController.uploadCovid19TestResults);
router.post('/health/permissions/view', healthController.viewPermissions);
router.delete('/health/permissions', healthController.deletePermissionRequest);

router.post('/health/permissions/permission-request', healthController.createPermissionRequest);
router.post('/health/permissions/permission-request/grant', healthController.grantPermission);
router.post('/health/permissions/permission-request/view', healthController.viewPermissionsRequestsCompanyId);
router.post('/health/contact-trace/group', healthController.viewGroup);
router.post('/health/contact-trace/shifts', healthController.viewShifts);
router.post('/health/contact-trace/notify-group', healthController.notifyGroup);

// Export API routes
module.exports = router;