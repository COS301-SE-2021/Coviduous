let router = require('express').Router();
let db = require("../config/shift_database.js");


/**
 * Default a Get router 
 */
 router.get('/', function (req, res) {
    res.json({
        status: 200,
        message: 'Shift Router'
    });
});
/**
 * 
 */
const Shift = require("../services/shift/shift.controller.js");


Shift.setDatabse(db);


/**
 * Shift Routes
 *  */
router.post('/shift',Shift.createShift);




// Export API routes
module.exports = router