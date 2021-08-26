let router = require('express').Router();

// import reporting controller
const reportingController = require("../services/reporting/reporting.controller.js");
//const reportingMockService = require("../services/reporting/reporting.controller.js");

// import database
const devDatabase = require("../config/reporting.firestore.database.js");
//const mockDatabase = require("../config/mock_database/reporting.firestore.mock.database.js");

// setting database
reportingController.setDatabase(devDatabase);
//reportingMockService.setDatabase(mockDatabase);

//reporting routes for mock testing
//router.post('/mock/reporting', reportingMockService.addSickEmployees);

// reporting routes
// health reports
router.post('/reporting/health/sick-employees', reportingController.addSickEmployee);
router.post('/reporting/health/sick-employees/view', reportingController.viewSickEmployees);

router.post('/reporting/health/recovered-employees',reportingController.addRecoveredEmployee);
router.post('/reporting/health/recovered-employees/view',reportingController.viewRecoveredEmployee);

// company reports
router.post('/reporting/company/company-data', reportingController.addCompanyData);
router.post('/reporting/company/company-data/view', reportingController.viewCompanyData);
router.put('/reporting/company/company-data/registered-users', reportingController.updateNumberOfRegisteredUsers);
router.put('/reporting/company/company-data/registered-admins', reportingController.updateNumberOfRegisteredAdmins);

router.post('/reporting/company/users-data', reportingController.generateUsersData);
router.post('/reporting/company/users-data/view', reportingController.viewUsersData);
router.put('/reporting/company/users-data/registered-users', reportingController.updateTotalRegisteredUsers);
//health reports
router.post('/reporting/health-summary', reportingController.setUpHealthSummary);

// Export API routes
module.exports = router;