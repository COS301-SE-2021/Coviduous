let router = require('express').Router();
let db = require("../config/shift.firestore.database.js");
let database = require("../config/mock_database/shift.firestore.mock.database");
/**
 * Default a Get router 
 */
 router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'Shift Router'
    });
});

const Shift = require("../services/shift/shift.controller.js");
//const ShiftMock = require("../services/shift/shift.controller.js");

Shift.setDatabase(db);
//ShiftMock.setDatabase(database);

/**
 * Shift Routes
 *  */
router.post('/shift',Shift.createShift);
router.post('/shift/getRoomShift',Shift.getRoomShift);
router.delete('/shift',Shift.deleteShift);
router.get('/shift',Shift.viewShifts);
router.put('/shift',Shift.updateShift);
/**
 * Group Routes
 */
router.get('/group',Shift.getGroup);
router.post('/group/shift-id',Shift.getGroupForShift);
router.post('/group',Shift.createGroup);

/**
 * shift mock routes 
 */
// router.post('/mock/shift',ShiftMock.createShift);
// router.delete('/mock/shift',ShiftMock.deleteShift);
// router.get('/mock/shift',ShiftMock.viewShifts);
// router.put('/mock/shift',ShiftMock.updateShift);

/**
 * group mock routes 
 */
// router.get('/mock/group',ShiftMock.getGroup);
// router.post('/mock/group/shift-id',ShiftMock.getGroupForShift);
// router.post('/mock/group',ShiftMock.createGroup);

// Export API routes
module.exports = router