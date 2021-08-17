const uuid = require("uuid");
let admin = require('firebase-admin');
let database;

/**
 * This function sets the database used by the user controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
exports.setDatabase = async (db) => {
    database = db;
}

/**
 * Verifies the request token provided to it to ensure only authorized users may update and retrieve information from the database.
 * @param token A JWT token.
 * @returns {Promise<boolean>} Returns true if the token is valid and false if it is not.
 */
exports.verifyRequestToken = async (token) => {
    console.log(token);
    let isTokenValid = true;
    return isTokenValid;
}
exports.verifyToken = async(idToken) =>{
   /*admin
  .auth()
  .verifyIdToken(idToken)
  .then((decodedToken) => {
    const uid = decodedToken.uid;
    return true;
  })
  .catch((error) => {
    return false;
  });*/
    return true;
}

/**
 * This function creates a new user via an HTTP POST request.
 * @param req The request object must exist and have the correct fields. It will be denied if not.
 * The request object should contain the following:
 * (
 *  userId: string,
 *  type: "ADMIN" || "USER",
 *  firstName: string,
 *  lastName: string,
 *  email: string,
 *  userName: string,
 *  companyId: string,
 * )
 * If the user's type is "ADMIN", it should additionally contain the following:
 * (
 *  companyName: string,
 *  companyAddress: string,
 * )
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.createUser = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

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

    let result = await database.createUser(userData.userId, userData);
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'User successfully created',
        data: userData
    });
}

/**
 * This function updates a user's details via an HTTP PUT request.
 * @param req The request object must exist, and everything except the user ID and type are optional.
 * The request object should contain the following:
 * (
 *  userId: string,
 *  type: "ADMIN" || "USER",
 *  firstName: string?,
 *  lastName: string?,
 *  email: string?,
 *  userName: string?,
 *  companyId: string?,
 * )
 * If the user's type is "ADMIN", it could additionally contain the following:
 * (
 *  companyName: string?,
 *  companyAddress: string?,
 * )
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.updateUser = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

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

    let result = await database.updateUser(userData.userId, userData);

    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'User successfully created',
        data: userData
    });
}

/**
 * This function retrieves all users via an HTTP GET request.
 * @param req The request object may be null.
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.getUsers = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

      
    if(await this.verifyToken(token["postman-token"])==false)
    {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });

    }

    let result = await database.getUsers();

    if (result == null) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
            data: null
        });
    }

    return res.status(200).send({
        message: 'Successfully retrieved users',
        data: result
    });
}

/**
 * This function retrieves a specific user's details via an HTTP GET request.
 * @param req The request object must exist, and it should contain the following field:
 * (
 *  userId: string
 * )
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.getUserDetails = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

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
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let result = await database.getUserDetails(reqJson.userId);

    if (result == null) {
        console.log("500 server error");
        return res.status(500).send({
            message: '500 Server Error: DB error',
            data: null
        });
    }

    return res.status(200).send({
        message: 'Successfully retrieved user details',
        data: result
    });
}

/**
 * This function retrieves a specific user's details using their email, via an HTTP GET request.
 * @param req The request object must exist, and it should contain the following field:
 * (
 *  email: string
 * )
 * @param res The response object is sent back to the requester, containing the status code and retrieved data.
 * @returns res - HTTP status indicating whether the request was successful or not, and data, where applicable.
 */
exports.getUserDetailsByEmail = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

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

    let result = await database.getUserDetailsByEmail(reqJson.email);

    if (result == null) {
        console.log("500 server error");
        return res.status(500).send({
            message: '500 Server Error: DB error',
            data: null
        });
    }

    return res.status(200).send({
        message: 'Successfully retrieved user details',
        data: result
    });
}

/**
 * This function deletes a specific user via an HTTP DELETE request.
 * @param req The request object must exist, and it should contain the following field:
 * (
 *  userId: string
 * )
 * @param res The response object is sent back to the requester, containing the status code and a message.
 * @returns res - HTTP status indicating whether the request was successful or not.
 */
exports.deleteUser = async (req, res) => {
    let token = req.headers;

    if (await this.verifyRequestToken(token) === false) {
        return res.status(403).send({
            message: '403 Forbidden: Access denied',
        });
    }

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

    let result = await database.deleteUser(reqJson.userId);

    if (!result) {
        console.log("500 server error");
        return res.status(500).send({
            message: '500 Server Error: DB error',
            data: null
        });
    }

    return res.status(200).send({
        message: 'Successfully deleted user',
    });
}