let router = require('express').Router();
let db = require("../config/shift.firestore.database.js");

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

Shift.setDatabase(db);

/**
 * Shift Routes
 *  */
router.post('/shift',Shift.createShift);
router.delete('/shift',Shift.deleteShift);
router.get('/shift',Shift.viewShifts);
router.put('/shift',Shift.updateShift);
/**
 * Group Routes
 */
router.get('/group',Shift.getGroup);
router.post('/group/shift-id',Shift.getGroupForShift);
router.post('/group',Shift.createGroup);

// Export API routes
module.exports = router