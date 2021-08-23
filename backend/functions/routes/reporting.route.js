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
//router.post('/mock/reportings', reportingMockService.addSickEmployees);

// reporting routes
//router.post('/reporting/health/addSickEmployees', reportingController.addSickEmployees);
//router.post('/reporting/health/addSickEmployees', reportingController.getSickEmployees);

// Export API routes
module.exports = router;