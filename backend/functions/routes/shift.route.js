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
/**
 * @swagger
 * /shift:
 *   post:
 *     description: create a shift
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/shift',Shift.createShift);
/**
 * @swagger
 * /shift/getRoomShift:
 *   post:
 *     description: retrieve shifts by room
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/shift/getRoomShift',Shift.getRoomShift);
/**
 * @swagger
 * /shift:
 *   delete:
 *     description: delete a shift
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.delete('/shift',Shift.deleteShift);
/**
 * @swagger
 * /shift:
 *   get:
 *     description: Get all shifts
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.get('/shift',Shift.viewShifts);
/**
 * @swagger
 * /shift:
 *   put:
 *     description: update a shift
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.put('/shift',Shift.updateShift);

/**
 * Group Routes
 */
/**
 * @swagger
 * /group:
 *   get:
 *     description: Get all shift groups
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.get('/group',Shift.getGroup);
/**
 * @swagger
 * /group/shift-id:
 *   post:
 *     description: retrieve groups by shift id
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/group/shift-id',Shift.getGroupForShift);
/**
 * @swagger
 * /group:
 *   post:
 *     description: create a shift group
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/group',Shift.createGroup);
/**
 * @swagger
 * /group/company-id:
 *   post:
 *     description: retrieve users in group by company id
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
router.post('/group/company-id',Shift.getEmailAssigned);

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