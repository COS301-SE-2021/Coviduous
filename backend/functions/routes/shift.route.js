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
router.post('shift/group',Shift.createGroup);
router.delete('/shift',Shift.deleteShift);
router.get('/shift',Shift.viewShifts);
//router.get('/shift/group',Shift.getGroup)
router.put('/shift',Shift.updateShift);
/**
 * Group Routes
 */
router.get('/group',);

// Export API routes
module.exports = router