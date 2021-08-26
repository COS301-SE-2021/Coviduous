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

////////// HEALTH REPORTING ////////////
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
        fieldErrors.push({field: 'userId', message: 'User ID may not be empty'})
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

    let viewRecovered = await database.viewRecoveredEmployee();
      
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

////////// COMPANY REPORTING ////////////

/////// company-data ////////
exports.addCompanyData = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }

    // if (reqJson.numberOfRegisteredUsers == null || reqJson.numberOfRegisteredUsers === "") {
    //     fieldErrors.push({field: 'numberOfRegisteredUsers', message: 'Number of registered users may not be empty'})
    // }

    // if (reqJson.numberOfRegisteredAdmins == null || reqJson.numberOfRegisteredAdmins === "") {
    //     fieldErrors.push({field: 'numberOfRegisteredAdmins', message: 'Number of registered admins may not be empty'})
    // }

    // if (reqJson.numberOfFloorplans == null || reqJson.numberOfFloorplans === "") {
    //     fieldErrors.push({field: 'numberOfFloorplans', message: 'Number of floorplans may not be empty'})
    // }

    // if (reqJson.numberOfFloors == null || reqJson.numberOfFloors === "") {
    //     fieldErrors.push({field: 'numberOfFloors', message: 'Number of floors may not be empty'})
    // }

    // if (reqJson.numberOfRooms == null || reqJson.numberOfRooms === "") {
    //     fieldErrors.push({field: 'numberOfRooms', message: 'Number of rooms may not be empty'})
    // }

    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }

    let companyData = {
        companyId: reqJson.companyId,
        numberOfRegisteredUsers: "0",
        numberOfRegisteredAdmins: "0",
        numberOfFloorplans: "0",
        numberOfFloors: "0",
        numberOfRooms: "0"
    }

    let result = await database.addCompanyData(companyData.companyId, companyData);
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
       message: 'Company data successfully created',
       data: companyData
    });
};

exports.viewCompanyData = async (req, res) => {
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

    let companyData = await database.getCompanyData(reqJson.companyId);

    if (companyData != null)
    {
        return res.status(200).send({
            message: 'Successfully retrieved company data',
            data: companyData
        });      
    }
    else
    {
        return res.status(500).send({message: "Some error occurred while fetching company data."});
    }
};

exports.updateNumberOfRegisteredUsers = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if(reqJson.numberOfRegisteredUsers == null || reqJson.numberOfRegisteredUsers === ''){
        fieldErrors.push({field: 'numberOfRegisteredUsers', message: 'Number of registered users may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
  
    if (await database.updateNumberOfRegisteredUsers(reqJson.companyId, reqJson.numberOfRegisteredUsers) == true) {
      return res.status(200).send({
        message: "Successfully updated number of registered users",
        data: req.body
      });
    } else {
      return res.status(500).send({message: "Some error occurred while updating number of registered users."});
    }
};

exports.updateNumberOfRegisteredAdmins = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if(reqJson.numberOfRegisteredAdmins == null || reqJson.numberOfRegisteredAdmins === ''){
        fieldErrors.push({field: 'numberOfRegisteredAdmins', message: 'Number of registered users may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
  
    if (await database.updateNumberOfRegisteredAdmins(reqJson.companyId, reqJson.numberOfRegisteredAdmins) == true) {
      return res.status(200).send({
        message: "Successfully updated number of registered admins",
        data: req.body
      });
    } else {
      return res.status(500).send({message: "Some error occurred while updating number of registered admins."});
    }
};

exports.addNumberOfFloorplansCompanyData = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let companyData = await database.getCompanyData(reqJson.companyId);

    if (await database.addNumberOfFloorplansCompanyData(reqJson.companyId, companyData.numberOfFloorplans) == true) {
        return res.status(200).send({
            message: "Successfully added number of floorplans",
            //data: req.body
        });
    } else {
        return res.status(500).send({message: "Some error occurred while updating number of floorplans."});
    }
};

exports.decreaseNumberOfFloorplansCompanyData = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let companyData = await database.getCompanyData(reqJson.companyId);

    if (await database.decreaseNumberOfFloorplansCompanyData(reqJson.companyId, companyData.numberOfFloorplans) == true) {
        return res.status(200).send({
            message: "Successfully decreased number of floorplans",
            //data: req.body
        });
    } else {
        return res.status(500).send({message: "Some error occurred while updating number of floorplans."});
    }
};

exports.addNumberOfFloorsCompanyData = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let companyData = await database.getCompanyData(reqJson.companyId);

    if (await database.addNumberOfFloorsCompanyData(reqJson.companyId, companyData.numberOfFloors) == true) {
        return res.status(200).send({
            message: "Successfully added number of floors",
            //data: req.body
        });
    } else {
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
};

exports.addNumberOfRoomsCompanyData = async (req, res) => {
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

    if (reqJson.companyId == null || reqJson.companyId === '') {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    
    let companyData = await database.getCompanyData(reqJson.companyId);

    if (await database.addNumberOfRoomsCompanyData(reqJson.companyId, companyData.numberOfRooms) == true) {
        return res.status(200).send({
            message: "Successfully added number of rooms",
            //data: req.body
        });
    } else {
        return res.status(500).send({message: "Some error occurred while updating number of rooms."});
    }
};


/////// users-data ////////
exports.generateUsersData = async (req, res) => {
    // if (req == null || req.body == null) {
    //     return res.status(400).send({
    //         message: '400 Bad Request: Null request object',
    //     });
    // }

    // //Look into express.js middleware so that these lines are not necessary
    // let reqJson;
    // try {
    //     reqJson = JSON.parse(req.body);
    // } catch (e) {
    //     reqJson = req.body;
    // }
    // console.log(reqJson);
    // //////////////////////////////////////////////////////////////////////

    // let fieldErrors = [];

    // if (reqJson.totalRegisteredUsers == null || reqJson.totalRegisteredUsers === "") {
    //     fieldErrors.push({field: 'totalRegisteredUsers', message: 'Total number of registered users may not be empty'})
    // }

    // if (reqJson.totalEmployees == null || reqJson.totalEmployees === "") {
    //     fieldErrors.push({field: 'totalEmployees', message: 'Total number of employees may not be empty'})
    // }

    // if (reqJson.totalAdmins == null || reqJson.totalAdmins === "") {
    //     fieldErrors.push({field: 'totalAdmins', message: 'Total number of admins may not be empty'})
    // }

    // if (fieldErrors.length > 0) {
    //     return res.status(400).send({
    //         message: '400 Bad Request: Incorrect fields',
    //         errors: fieldErrors
    //     });
    // }

    // get total users
    let totalUsers = await database.getTotalUsers();
    totalUsers = totalUsers.toString();

    // get total employees
    let totalEmployees = await database.getTotalEmployees();
    totalEmployees = totalEmployees.toString();

    // get total admins
    let totalAdmins = await database.getTotalAdmins();
    totalAdmins = totalAdmins.toString();

    let usersDataId = "UD-" + uuid.v4();

    let usersData = {
        usersDataId: usersDataId,
        totalRegisteredUsers: totalUsers,
        totalEmployees: totalEmployees,
        totalAdmins: totalAdmins
    }

    let result = await database.generateUsersData(usersData.usersDataId, usersData);
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
       message: 'Users data successfully created',
       data: usersData
    });
};

exports.viewUsersData = async (req, res) => {
    let result = await database.viewUsersData();
    
    if (!result) {
        return res.status(500).send({
            message: '500 Server Error: DB error',
        });
    }

    return res.status(200).send({
        message: 'Successfully retrieved users data',
        data: result
    });
};

exports.updateTotalRegisteredUsers = async (req, res) => {
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

    if (reqJson.usersDataId == null || reqJson.usersDataId === '') {
        fieldErrors.push({field: 'usersDataId', message: 'Users data ID may not be empty'});
    }

    if(reqJson.totalRegisteredUsers == null || reqJson.totalRegisteredUsers === ''){
        fieldErrors.push({field: 'totalRegisteredUsers', message: 'Total number of registered users may not be empty'});
    }

    if (fieldErrors.length > 0) {
        console.log(fieldErrors);
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
  
    if (await database.updateTotalRegisteredUsers(reqJson.usersDataId, reqJson.totalRegisteredUsers) == true) {
      return res.status(200).send({
        message: "Successfully updated total number of registered users",
        data: req.body
      });
    } else {
      return res.status(500).send({message: "Some error occurred while updating total number of registered users."});
    }
};


// health summary 
//initial setup
exports.setUpHealthSummary = async (req, res) => {
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
    let healthSummaries = await database.viewHealthSummary();
    
    let filteredList=[];   
    healthSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });

    if(filteredList.length>0)
    {
        // company was previously initialized no need to re-initilize
        return res.status(200).send({
            message: 'Company Health Summary Already Has An Initial Instance',
        });

    }
    else
    {
      let healthSummaryId = "HSID-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);

      let healthSummary = {
        healthSummaryId: healthSummaryId,
        month: month,
        year:year,
        timestamp: timestamp,
        companyId: reqJson.companyId,
        numHealthChecksUsers: 0,
        numHealthChecksVisitors: 0,
        numReportedInfections: 0,
        numRecovered: 0,
          
        }
        await database.setHealthSummary(healthSummaryId,healthSummary);
        return res.status(200).send({
            message: 'Company Health Summary Successfuly Set',
            data:healthSummary
        });


    }


};
