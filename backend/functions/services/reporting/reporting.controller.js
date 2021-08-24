const uuid = require("uuid");

let database;

/**
 * This function sets the database used by the office controller.
 * @param db The database to be used. It can be any interface with CRUD operations.
 */
 exports.setDatabase = async(db) => {
    database = db;
}

/**
 * This function returns the current date in a specified format.
 * @returns {string} The current date as a string in the format DD/MM/YYYY
 */
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"
      +(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

/**
 * This function returns the current time in a specified format.
 * @returns {string} The current time as a string in the format HH:MM:SS.
 */
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"
       + ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"
       + ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

// functions
exports.addSickEmployee = async (req, res) => {
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

    if (reqJson.userId == null || reqJson.userId === "") {
        fieldErrors.push({field: 'userId', message: 'UserID may not be empty'})
    }

    if (reqJson.userEmail == null || reqJson.userEmail === "") {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'})
    }

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    //let sickEmployeeId = "SCK-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let sickEmployeeData = {
        //sickEmployeeId: sickEmployeeId,
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        timeOfDiagnosis: timestamp,
        companyId: reqJson.companyId
    }

    let result = await database.addSickEmployee(sickEmployeeData.userId, sickEmployeeData);
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
       message: 'Sick employee successfully created',
       data: sickEmployeeData
    });
};

exports.addRecoveredEmployee= async (req,res) =>{
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);
   
    let fieldErrors = [];

    if (reqJson.userId == null || reqJson.userId === "") {
        fieldErrors.push({field: 'userId', message: 'UserID may not be empty'})
    }

    if (reqJson.userEmail == null || reqJson.userEmail === "") {
        fieldErrors.push({field: 'userEmail', message: 'User email may not be empty'})
    }

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let recoveredData = {
        
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        recoveredTime: timestamp,
        companyId: reqJson.companyId
    }

    let result = await database.addRecoveredEmployee(recoveredData.userId,recoveredData);
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
       message: 'Recovered employee successfully created',
       data: recoveredData
    });
};
exports.viewRecoveredEmployee = async (req, res) => {

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

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let viewRecovered = await db.viewRecoveredEmployee();
      
    if (viewRecovered != null) {
      return res.status(200).send({
        message: 'Successfully retrieved recovered employees',
        data: viewRecovered
      });
    } else {
      return res.status(500).send({message: "Some error occurred while recovered employees"});
    }
};

// exports.viewSickEmployees = async (req, res) => {
//     let result = await database.viewSickEmployees();
    
//     if (!result) {
//         return res.status(500).send({
//             message: '500 Server Error: DB error',
//             data: null
//         });
//     }

//     return res.status(200).send({
//         message: 'Successfully retrieved sick employees',
//         data: result
//     });
// };

exports.viewSickEmployees = async (req, res) => {
    let fieldErrors = [];

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    console.log(reqJson);

    if(req.body == null) {
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

    let sickEmployees = await database.viewSickEmployees(reqJson.companyId);

    if (sickEmployees != null)
    {
        return res.status(200).send({
            message: 'Successfully retrieved sick employees',
            data: sickEmployees
        });      
    }
    else
    {
        return res.status(500).send({message: "Some error occurred while fetching sick employees."});
    }
};