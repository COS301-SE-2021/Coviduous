let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let userApp = express();
//var serviceAccount = require("./permissions.json");
const authMiddleware = require('../authMiddleWare.js');

userApp.use(cors({ origin: true }));
userApp.use(express.urlencoded({ extended: true }));
userApp.use(express.json());
//admin.initializeApp(); 


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

/**
 * @swagger
 * /users:
 *   post:
 *     description: create a user
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
userApp.post('/api/users', async (req, res) => {
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

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (reqJson.type == null || reqJson.type === '') {
        fieldErrors.push({field: 'type', message: 'Type may not be empty'});
    }

    if (reqJson.type !== 'ADMIN' && reqJson.type !== 'USER') {
        fieldErrors.push({field: 'type', message: 'Type must be either ADMIN or USER'});
    }

    if (reqJson.type === 'ADMIN') {
        if (reqJson.companyName == null || reqJson.companyName === '') {
            fieldErrors.push({field: 'companyName', message: 'Company name may not be empty for admins'});
        }

        if (reqJson.companyAddress == null || reqJson.companyAddress === '') {
            fieldErrors.push({field: 'companyAddress', message: 'Company address may not be empty for admins'});
        }
    }

    if (reqJson.firstName == null || reqJson.firstName === '') {
        fieldErrors.push({field: 'firstName', message: 'First name may not be empty'});
    }

    if (reqJson.lastName == null || reqJson.lastName === '') {
        fieldErrors.push({field: 'lastName', message: 'Last name may not be empty'});
    }

    if (reqJson.email == null || reqJson.email === '') {
        fieldErrors.push({field: 'email', message: 'Email may not be empty'});
    }

    if (reqJson.userName == null || reqJson.userName === '') {
        fieldErrors.push({field: 'userName', message: 'Username may not be empty'});
    }

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let userData;

    if (reqJson.type === 'ADMIN') {
        userData = {
            userId: reqJson.userId,
            type: reqJson.type,
            firstName: reqJson.firstName,
            lastName: reqJson.lastName,
            email: reqJson.email,
            userName: reqJson.userName,
            companyId: reqJson.companyId,
            companyName: reqJson.companyName,
            companyAddress: reqJson.companyAddress,
        };
    }

    if (reqJson.type === 'USER') {
        userData = {
            userId: reqJson.userId,
            type: reqJson.type,
            firstName: reqJson.firstName,
            lastName: reqJson.lastName,
            email: reqJson.email,
            userName: reqJson.userName,
            companyId: reqJson.companyId,
        };
    }

    try {
        await database.collection('users').doc(reqJson.userId)
            .create(userData);

        // company-data summary
        if (reqJson.type === 'USER')
        {
            //let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
            let response = database.collection('company-data').doc(reqJson.companyId);
            let doc = await response.get();
            let res = doc.data()

            //await reportingDatabase.addNumberOfRegisteredUsersCompanyData(reqJson.companyId, companyData.numberOfRegisteredUsers);
            if (parseInt(res.numberOfRegisteredUsers) >= 0)
            {
                let newNumRegisteredUsers = parseInt(res.numberOfRegisteredUsers) + 1;
                newNumRegisteredUsers = newNumRegisteredUsers.toString();

                response = await database.collection('company-data').doc(reqJson.companyId).update({
                    "numberOfRegisteredUsers": newNumRegisteredUsers
                });
            }
        }
        else if (reqJson.type === 'ADMIN')
        {
            //let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
            let response = database.collection('company-data').doc(reqJson.companyId);
            let doc = await response.get();
            let res = doc.data()

            //await reportingDatabase.addNumberOfRegisteredAdminsCompanyData(reqJson.companyId, companyData.numberOfRegisteredAdmins);
            if (parseInt(res.numberOfRegisteredAdmins) >= 0)
            {
                let newNumRegisteredAdmins = parseInt(res.numberOfRegisteredAdmins) + 1;
                newNumRegisteredAdmins = newNumRegisteredAdmins.toString();

                response = await database.collection('company-data').doc(reqJson.companyId).update({
                    "numberOfRegisteredAdmins": newNumRegisteredAdmins
                });
            }
        }

        return res.status(200).send({
            message: 'User successfully created',
            data: userData
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
 * /users:
 *   delete:
 *     description: delete a user
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
userApp.delete('/api/users', async (req, res) => {
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

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        //let result2 = await database.getUserDetails(reqJson.userId);
        let document = database.collection('users').where("userId", "==", reqJson.userId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data);
            list.push(data);
        });

        //console.log(list[0].type)
        
        // company-data summary
        if (list[0].type === 'USER')
        {
            //let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
            let response = database.collection('company-data').doc(list[0].companyId);
            let doc = await response.get();
            let res = doc.data()
            
            //await reportingDatabase.decreaseNumberOfRegisteredUsersCompanyData(reqJson.companyId, companyData.numberOfRegisteredUsers);
            if (parseInt(res.numberOfRegisteredUsers) > 0)
            {
                let newNumRegisteredUsers = parseInt(res.numberOfRegisteredUsers) - 1;
                newNumRegisteredUsers = newNumRegisteredUsers.toString();

                response = await database.collection('company-data').doc(list[0].companyId).update({
                    "numberOfRegisteredUsers": newNumRegisteredUsers
                });
            }
        }
        else if (list[0].type === 'ADMIN')
        {
            //let companyData = await reportingDatabase.getCompanyData(reqJson.companyId);
            let response = database.collection('company-data').doc(list[0].companyId);
            let doc = await response.get();
            let res = doc.data()

            //await reportingDatabase.decreaseNumberOfRegisteredAdminsCompanyData(reqJson.companyId, companyData.numberOfRegisteredAdmins);
            if (parseInt(res.numberOfRegisteredAdmins) > 0)
            {
                let newNumRegisteredAdmins = parseInt(res.numberOfRegisteredAdmins) - 1;
                newNumRegisteredAdmins = newNumRegisteredAdmins.toString();
                
                response = await database.collection('company-data').doc(list[0].companyId).update({
                    "numberOfRegisteredAdmins": newNumRegisteredAdmins
                });
            }
        }

        const document2 = database.collection('users').doc(reqJson.userId);
        await document2.delete();

        return res.status(200).send({
            message: 'User successfully deleted'
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
 * /users:
 *   put:
 *     description: update a user's details
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
userApp.put('/api/users',  async (req, res) => {
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

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (reqJson.type == null || reqJson.type === '') {
        fieldErrors.push({field: 'type', message: 'Type may not be empty'});
    }

    if (reqJson.type !== 'ADMIN' && reqJson.type !== 'USER') {
        fieldErrors.push({field: 'type', message: 'Type must be either ADMIN or USER'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    let userData;

    if (reqJson.type === 'ADMIN') {
        userData = {
            userId: reqJson.userId,
            firstName: reqJson.firstName,
            lastName: reqJson.lastName,
            email: reqJson.email,
            userName: reqJson.userName,
            companyName: reqJson.companyName,
            companyAddress: reqJson.companyAddress,
        };
    }

    if (reqJson.type === 'USER') {
        userData = {
            userId: reqJson.userId,
            firstName: reqJson.firstName,
            lastName: reqJson.lastName,
            email: reqJson.email,
            userName: reqJson.userName,
        };
    }

    try {
        const document = await database.collection('users').doc(reqJson.userId);
        await document.update({
            ...((userData.firstName != null && userData.firstName !== "") && {firstName: userData.firstName}),
            ...((userData.lastName != null && userData.lastName !== "") && {lastName: userData.lastName}),
            ...((userData.email != null && userData.email !== "") && {email: userData.email}),
            ...((userData.userName != null && userData.userName !== "") && {userName: userData.userName}),
            ...((userData.companyName != null && userData.companyName !== "") && {companyName: userData.companyName}),
            ...((userData.companyAddress != null && userData.companyAddress !== "") && {companyAddress: userData.companyAddress}),
        });

        return res.status(200).send({
            message: "Successfully updated user",
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
 * /users:
 *   get:
 *     description: Get all users
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 userApp.get('/api/users', async (req, res) => {
    try {
        const document = database.collection('users');
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved users',
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
 * /users:
 *   post:
 *     description: retrieve users by user id
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
userApp.post('/api/users/user-id', async (req, res) => {
    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.userId == null || reqJson.userId === '') {
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        //console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        let document = database.collection('users').where("userId", "==", reqJson.userId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved user details',
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
 * /users:
 *   post:
 *     description: retrieve users by user email
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
userApp.post('/api/users/email', async (req, res) => {
    if (req == null || req.body == null) {
        return res.status(400).send({
            message: '400 Bad Request: Null request object',
        });
    }

    //Look into express.js middleware so that these lines are not necessary
    let reqJson;
    try {
        reqJson = JSON.parse(req);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
    //////////////////////////////////////////////////////////////////////

    let fieldErrors = [];

    if (reqJson.email == null || reqJson.email === '') {
        fieldErrors.push({field: 'email', message: 'User email may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    try {
        let document = database.collection('users').where("email", "==", reqJson.email);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data)
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved user details',
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


exports.user = functions.https.onRequest(userApp);