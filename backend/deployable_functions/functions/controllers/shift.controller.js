let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let shiftApp = express();
const authMiddleware = require('../authMiddleWare.js');

shiftApp.use(cors({ origin: true }));
shiftApp.use(express.urlencoded({ extended: true }));
shiftApp.use(express.json()); 

shiftApp.use(authMiddleware); 

let database = admin.firestore();
let uuid = require("uuid");

 /**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
  Date.prototype.today = function () { 
    return ((this.getDate() < 10)?"0":"") + this.getDate() + "/" +
        (((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
  }
  
  /**
  * This function returns the current time in a specified format.
  * @returns {string} The current time as a string in the format HH:MM:SS.
  */
  Date.prototype.timeNow = function () {
    return ((this.getHours() < 10)?"0":"") + this.getHours() + ":" +
        ((this.getMinutes() < 10)?"0":"") + this.getMinutes() + ":" +
        ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
  }

///////////////// functions /////////////////

///// shifts //////

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
shiftApp.post('/api/shift',  async (req, res) => {
    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.date == null || reqJson.date === '') {
        fieldErrors.push({field: 'date', message: 'Date may not be empty'});
    }

    if (reqJson.startTime == null || reqJson.startTime === '') {
        fieldErrors.push({field: 'startTime', message: 'Start time may not be empty'});
    }

    if (reqJson.endTime == null || reqJson.endTime === '') {
        fieldErrors.push({field: 'endTime', message: 'End time may not be empty'});
    }

    if (reqJson.description == null || reqJson.description === '') {
        fieldErrors.push({field: 'description', message: 'Description may not be empty'});
    }

    if (reqJson.adminId == null || reqJson.adminId === '') {
        fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (reqJson.floorPlanNumber == null || reqJson.floorPlanNumber === '') {
        fieldErrors.push({field: 'floorPlanNumber', message: 'Floor plan number may not be empty'});
    }

    if (reqJson.floorNumber == null || reqJson.floorNumber === '') {
        fieldErrors.push({field: 'floorNumber', message: 'Floor number may not be empty'});
    }

    if (reqJson.roomNumber == null || reqJson.roomNumber === '') {
        fieldErrors.push({field: 'roomNumber', message: 'Room number may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let shiftID = "SHI-" + uuid.v4();
    let summary = "SUM-"+uuid.v4();

    let shiftData = { shiftID: shiftID, date: reqJson.date, startTime: reqJson.startTime, endTime: reqJson.endTime,
        description: reqJson.description, adminId: reqJson.adminId, companyId: reqJson.companyId, floorPlanNumber: reqJson.floorPlanNumber,
        floorNumber: reqJson.floorNumber, roomNumber: reqJson.roomNumber };

        let time = new Date();
        let year = time.getFullYear();
        let month = time.getMonth()+1;
    
        let data ={
            summaryShiftId: summary,
            companyId: reqJson.companyId,
            numShifts: 1,
            month: month,
            year: year
        }

    try {
        await database.collection('shifts').doc(shiftID)
            .create(shiftData);

        //summary
        let c = "";
        const document =  database.collection('summary-shifts').where("month","==",month);
        let snapshot = await document.get(); 

        let list = [];

        snapshot.forEach(doc => {
            let d = doc.data();
            list.push(d);
        });
        
    
        for (const element of list) {
            if(data.month===element.month){
                c="checked";  
            }
        }
        
        if(c==="")
        {
            await database.collection('summary-shifts').doc(summary)
            .create(data); 
        }

        if(c==="checked")
        {
            const documents =  database.collection('summary-shifts').where("month","==",month);
            let s = await documents.get(); 
    
            let lists = [];
    
            s.forEach(doc => {
                let ds = doc.data();
                lists.push(ds);
            });
            
            let summaryId;
            let count;
            for (const elements of lists) {
                
                summaryId = elements.summaryShiftId;
                count =elements.numShifts;

            }

            let numShifts = parseInt(count) + 1;
            numShifts = numShifts.toString();
        
            
            const documented = database.collection('summary-shifts').doc(summaryId);
            await documented.update({ 
                numShifts:numShifts
            });
        }

        return res.status(200).send({
            message: 'Shift successfully created',
            data: shiftData
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.delete('/api/shift', async (req, res) => {
    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftId == null || reqJson.shiftId === '') {
        fieldErrors.push({field: 'shiftId', message: 'Shift ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        // let group = await db.getGroupForShift(reqJson.shiftId);
        const document = database.collection('groups').where("shiftNumber", "==", reqJson.shiftId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        //console.log(list);

        //await db.deleteGroup(group.groupId);
        const document2 = database.collection('groups').doc(list[0].groupId);
        await document2.delete();

        // summary
        const documents = database.collection('shifts').where("shiftID","==",reqJson.shiftId);
        const snapshot2 = await documents.get();
       
        let list2 = [];

        snapshot2.forEach(doc => {
            let data = doc.data();
            list2.push(data);
        });

        let companyId;

        for (const element of list2) {
            companyId = element.companyId;
        }

        const doc =   database.collection('summary-shifts').where("companyId","==",companyId) 
        const snap = await doc.get();    
         
        
        let lists = [];

        snap.forEach(docs => {
            let dat = docs.data();
            lists.push(dat);
        });
        
        let numShifts;
        let summaryId;
        for (const element of lists) {
            summaryId = element.summaryShiftId,
            numShifts = element.numShifts;
            }
            
        let numShift = parseInt(numShifts)-1;
        numShift = numShift.toString();   
       
        const documented = database.collection('summary-shifts').doc(summaryId);
        await documented.update({ 
            numShifts:numShift
        });   

        const document3 = database.collection('shifts').doc(reqJson.shiftId);
        await document3.delete();

        return res.status(200).send({
            message: 'Shift successfully deleted',
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
 shiftApp.put('/api/shift', async (req, res) => {
    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////
       
    if(req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftId == null || reqJson.shiftId === '') {
        fieldErrors.push({field: 'shiftId', message: 'Shift ID may not be empty'});
    }
    if(reqJson.endTime == null || reqJson.endTime === ''){
        fieldErrors.push({field: 'endTime', message: 'End time may not be empty'});
    }
    if(reqJson.startTime == null || reqJson.startTime === ''){
        fieldErrors.push({field: 'startTime', message: 'Start time may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
  
    try {
        const document = database.collection('shifts').doc(reqJson.shiftId);
        await document.update({
            startTime:reqJson.startTime,
            endTime:reqJson.endTime
        });

        return res.status(200).send({
            message: "Successfully updated shift",
            data: req.body
        });
    }
    catch (error) {
        console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.get('/api/shift', async (req, res) => {
    try {
        const document = database.collection('shifts');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved shifts',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.post('/api/shift/getRoomShift', async (req, res) => {

    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.roomNumber == null || reqJson.roomNumber === '') {
        fieldErrors.push({field: 'roomNumber', message: 'roomNumber may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('shifts').where("roomNumber", "==", reqJson.roomNumber);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved shifts',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});



///// shift groups /////

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
shiftApp.post('/api/group', async (req, res) => {
    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.groupName == null || reqJson.groupName === '') {
        fieldErrors.push({field: 'groupName', message: 'Group name may not be empty'});
    }

    if (reqJson.userEmails == null || reqJson.userEmails === '') {
        fieldErrors.push({field: 'userEmails', message: 'There must be at least one user email'});
    }

    if (reqJson.shiftNumber == null || reqJson.shiftNumber === '') {
        fieldErrors.push({field: 'shiftNumber', message: 'Shift number may not be empty'});
    }

    if (reqJson.adminId == null || reqJson.adminId === '') {
        fieldErrors.push({field: 'adminId', message: 'Admin ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let groupId = "GRP-" + uuid.v4();
    let groupData = { groupId: groupId, groupName: reqJson.groupName,
        userEmails: reqJson.userEmails, shiftNumber: reqJson.shiftNumber, adminId: reqJson.adminId };

        
    try {
        await database.collection('groups').doc(groupId)
            .create(groupData);

        return res.status(200).send({
            message: 'Shift group successfully created',
            data: groupData
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.get('/api/group', async (req, res) => {
    try {
        const document = database.collection('groups');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved shift groups',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.post('/api/group/shift-id', async (req, res) => {

    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.shiftNumber == null || reqJson.shiftNumber === '') {
        fieldErrors.push({field: 'shiftNumber', message: 'shiftNumber may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('groups').where("shiftNumber", "==", reqJson.shiftNumber);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved shift groups',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

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
shiftApp.post('/api/group/company-id', async (req, res) => {

    // data validation
    let fieldErrors = [];

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    if (req.body == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'companyId may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        const document = database.collection('users').where("companyId","==",reqJson.companyId);
        const snapshot = await document.get();
 
        let list =[];
 
         snapshot.forEach(doc => {
             let data = doc.data();
             list.push(data);
         });

        return res.status(200).send({
            message: 'Successfully retrieved user emails',
            data: list
        });
    } catch (error) {
        //console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});



exports.shift = functions.https.onRequest(shiftApp);