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
router.delete('/reporting/health/sick-employees', reportingController.deleteSickEmployee);
router.post('/reporting/health/sick-employees/view', reportingController.viewSickEmployees);

router.post('/reporting/health/recovered-employees',reportingController.addRecoveredEmployee);
router.post('/reporting/health/recovered-employees/view',reportingController.viewRecoveredEmployee);

// company reports
router.post('/reporting/company/company-data', reportingController.addCompanyData);
router.post('/reporting/company/company-data/view', reportingController.viewCompanyData);
//router.put('/reporting/company/company-data/registered-users', reportingController.updateNumberOfRegisteredUsers);
//router.put('/reporting/company/company-data/registered-admins', reportingController.updateNumberOfRegisteredAdmins);
router.put('/reporting/company/company-data/floorplans/inc', reportingController.addNumberOfFloorplansCompanyData);
router.put('/reporting/company/company-data/floorplans/dec', reportingController.decreaseNumberOfFloorplansCompanyData);
router.put('/reporting/company/company-data/floors/inc', reportingController.addNumberOfFloorsCompanyData);
router.put('/reporting/company/company-data/floors/dec', reportingController.decreaseNumberOfFloorsCompanyData);
router.put('/reporting/company/company-data/rooms/inc', reportingController.addNumberOfRoomsCompanyData);
router.put('/reporting/company/company-data/rooms/dec', reportingController.decreaseNumberOfRoomsCompanyData);

router.post('/reporting/company/users-data', reportingController.generateUsersData);
router.post('/reporting/company/users-data/view', reportingController.viewUsersData);
//router.put('/reporting/company/users-data/registered-users', reportingController.updateTotalRegisteredUsers);

//health reports
router.post('/reporting/health-summary/setup', reportingController.setUpHealthSummary);
router.post('/reporting/health-summary', reportingController.getHealthSummary);

//permission reports
router.post('/reporting/permission-summary/setup', reportingController.setUpPermissionSummary);
router.post('/reporting/permission-summary', reportingController.getPermissionSummary);
//Booking reporting
router.post('/reporting/summary-bookings',reportingController.getNumberBookings);

//Shifts reporting
router.post('/reporting/summary-shifts',reportingController.getNumberShifts);

// Export API routes
module.exports = router;