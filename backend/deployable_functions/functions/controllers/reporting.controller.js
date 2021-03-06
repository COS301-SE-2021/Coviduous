let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let reportingApp = express();
const authMiddleware = require('../authMiddleWare.js');

reportingApp.use(cors({ origin: true }));
reportingApp.use(express.urlencoded({ extended: true }));
reportingApp.use(express.json());

reportingApp.use(authMiddleware);


let database = admin.firestore();
let uuid = require("uuid");

/**
 * @swagger
 * /reporting/health/sick-employees:
 *   post:
 *     description: add a sick employee
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/health/sick-employees',async (req, res) =>  {
   
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

    
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let sickEmployeeData = {
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        timeOfDiagnosis: timestamp,
        companyId: reqJson.companyId
    }

    try {
        await database.collection('sick-employees').doc(sickEmployeeData.userId)
          .create(sickEmployeeData);
          return res.status(200).send({
            message: 'Sick Employee successfully created',
            data: sickEmployeeData
         });
    } catch (error) {
      console.log(error);
        return res.status(500).send({
            message: '500 Server Error: DB error',
            error: error
        });
    }
});

/**
 * @swagger
 * /reporting/health/recovered-employees:
 *   post:
 *     description: add a recovered employee
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/health/recovered-employees', async (req, res) =>  {
 
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
    
        try {
            await database.collection('recovered-employees').doc(recoveredData.userId)
              .create(recoveredData);
              return res.status(200).send({
                message: 'Recovered Employee successfully created',
                data: recoveredData
             });
        } catch (error) {
          console.log(error);
            return res.status(500).send({
                message: '500 Server Error: DB error',
                error: error
            });
        }
});

/**
 * @swagger
 * /reporting/health/recovered-employees/view:
 *   post:
 *     description: retrieve all sick employees
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/health/recovered-employees/view',async (req, res) =>  {

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
    if (reqJson.companyId == null || reqJson.companyId === "") {
        fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'})
    }
    if (fieldErrors.length > 0) {
        return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
        });
    }
    try{
        const document = database.collection('recovered-employees').where("companyId", "==", reqJson.companyId);
        const snapshot = await document.get();
    
        let list =[];
       snapshot.forEach(doc => {
          let data = doc.data();
            list.push(data);
        });
        return res.status(200).send({
            message: 'Successfully retrieved recovered-employees',
            data: list
        });
    
    }catch(error){
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching recovered-employees."}); 
    }    
});

/**
 * @swagger
 * /reporting/health/sick-employees/view:
 *   post:
 *     description: retrieve all sick employees
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/health/sick-employees/view', async (req, res) =>  {
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


    try{
        const document = database.collection('sick-employees').where("companyId", "==", reqJson.companyId);
        const snapshot = await document.get();
    
        let list =[];
       snapshot.forEach(doc => {
          let data = doc.data();
            list.push(data);
        });

        return res.status(200).send({
            message: 'Successfully retrieved sick-employees',
            data: list
        });
    
    }catch(error){
        console.log(error);
        return res.status(500).send({message: "Some error occurred while fetching sick-employees."}); 

    }    
});

/**
 * @swagger
 * /reporting/health/sick-employees:
 *   delete:
 *     description: delete a sick employee
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.delete('/api/reporting/health/sick-employees',async (req, res) =>  {
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
        const document = database.collection('sick-employees').doc(reqJson.userId);
        await document.delete();

        return res.status(200).send({
          message: 'Sick-employees successfully deleted'
       });
  } catch (error) {
    console.log(error);
      return res.status(500).send({
          message: '500 Server Error: DB error',
          error: error
      });        


    }

});

/**
 * @swagger
 * /reporting/company/company-data:
 *   post:
 *     description: create company data summary
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/company/company-data',async (req, res) => {
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

    let response = database.collection('company-data').doc(reqJson.companyId);
        let doc = await response.get();
        let result2 = doc.data()
    
    if (result2 != null) // check if entry exists in database
    {
        return res.status(200).send({
            message: 'Database entry already exists for companyId:' + reqJson.companyId,
        });
    }
    else
    {
        try {
            await database.collection('company-data').doc(companyData.companyId)
              .create(companyData);
              return res.status(200).send({
                message: 'Company Data successfully created',
                data: companyData
             });
        } catch (error) {
          console.log(error);
            return res.status(500).send({
                message: '500 Server Error: DB error',
                error: error
            });
        }
              
    }
});

/**
 * @swagger
 * /reporting/company/company-data/view:
 *   post:
 *     description: retrieve all company data summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/company/company-data/view',async (req, res) =>  {
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
      
    let response = database.collection('company-data').doc(reqJson.companyId);
        let doc = await response.get();
        let companyData = doc.data()
    
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
});
reportingApp.put('/api/reporting/company/company-data/registered-users',async (req, res) =>  {

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
    
        try {
            const document = database.collection('company-data').doc(reqJson.companyId);
    
            await document.update({
                numberOfRegisteredUsers: reqJson.numberOfRegisteredUsers
            });
            return res.status(200).send({
                message: 'Successfully updated company data',
            });
        }catch (error) {
            console.log(error);
              return res.status(500).send({
                  message: '500 Server Error: DB error',
                  error: error
              });
          }
    });
    reportingApp.put('/api/reporting/company/company-data/registered-admins', async (req, res) =>  {
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
    
        try {
            const document = database.collection('company-data').doc(reqJson.companyId);
    
            await document.update({
                numberOfRegisteredAdmins: reqJson.numberOfRegisteredAdmins
            });
            return res.status(200).send({
                message: 'Successfully updated company data',
            });
        }catch (error) {
            console.log(error);
              return res.status(500).send({
                  message: '500 Server Error: DB error',
                  error: error
              });
          }
    });
reportingApp.put('/api/reporting/company/company-data/floorplans/inc', async (req, res) =>  {
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
         
         
         let response = database.collection('company-data').doc(reqJson.companyId);
         let doc = await response.get();
         let companyData = doc.data();
         let currentNumFloorplansInCompanyData =companyData.numberOfFloorplans;
     
     
     
         try {
             if (parseInt(currentNumFloorplansInCompanyData) >= 0)
             {
                 let newNumFloorplans = parseInt(currentNumFloorplansInCompanyData) + 1;
                 newNumFloorplans = newNumFloorplans.toString();
     
                 response = await database.collection('company-data').doc(reqJson.companyId).update({
                     "numberOfFloorplans": newNumFloorplans
                 });
                 return res.status(200).send({
                     message: "Successfully added number of floorplans",
                     //data: req.body
                 });
         
             }
         } catch (error) {
             console.log(error);
             return res.status(500).send({message: "Some error occurred while updating number of floorplans."});
             
         }
});
reportingApp.put('/api/reporting/company/company-data/floors/inc', async (req, res) =>  {

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

    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorsInCompanyData = companyData.numberOfFloorplans;

    try {
        if (parseInt(currentNumFloorsInCompanyData) >= 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) + 1;
            newNumFloors = newNumFloors.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfFloors": newNumFloors
            });
            return res.status(200).send({
                message: "Successfully added number of floors",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }    
});
reportingApp.put('/api/reporting/company/company-data/floors/dec',async (req, res) =>  {    

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
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumFloorsInCompanyData = companyData.numberOfFloors;

    try {
        if (parseInt(currentNumFloorsInCompanyData) >= 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) - 1;
            newNumFloors = newNumFloors.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfFloors": newNumFloors
            });
            return res.status(200).send({
                message: "Successfully deleted number of floors",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
});
reportingApp.put('/api/reporting/company/company-data/rooms/inc', async (req, res) =>  {    
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
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumRoomsInCompanyData = companyData.numberOfRooms;


    try {
        if (parseInt(currentNumRoomsInCompanyData) >= 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) + 1;
            newNumRooms = newNumRooms.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfRooms": newNumRooms
            });
            return res.status(200).send({
                message: "Successfully added number of rooms",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }    
});

reportingApp.put('/api/reporting/company/company-data/rooms/dec', async (req, res) =>  {    
    
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
    
    
    let response = database.collection('company-data').doc(reqJson.companyId);
    let doc = await response.get();
    let companyData = doc.data();
    let currentNumRoomsInCompanyData = companyData.numberOfRooms;


    try {
        if (parseInt(currentNumRoomsInCompanyData) >= 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) - 1;
            newNumRooms = newNumRooms.toString();

            response = await database.collection('company-data').doc(reqJson.companyId).update({
                "numberOfRooms": newNumRooms
            });
            return res.status(200).send({
                message: "Successfully deleted number of rooms",
                //data: req.body
            });
            
        }
    } catch (error) {
        console.log(error);
        return res.status(500).send({message: "Some error occurred while updating number of floors."});
    }
});

/**
 * @swagger
 * /reporting/health-summary/setup:
 *   post:
 *     description: create health summary
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
reportingApp.post('/api/reporting/health-summary/setup', async (req, res) =>  {    
    
    let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
        
        // First we get all the health summaries in our database and check if there is an exisiting health summary with
        // our companyId

        if (reqJson.companyId == null || reqJson.companyId === '') {
            fieldErrors.push({field: 'companyId', message: 'Company ID may not be empty'});
        }
        
            const document = database.collection('health-summary');
            const snapshot = await document.get();
            
            let list = [];
            
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
        
        let healthSummaries =list;
    
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
            
          //company was never registered before so we setup their health summary table
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
            numReportedRecoveries:0
              
            }
            try{
                await database.collection('health-summary').doc(healthSummaryId)
                .create(healthSummary);
                 return res.status(200).send({
                message: 'Company Health Summary Successfuly Set',
                data:healthSummary
            });
        } catch (error) {
            console.log(error);
            return res.status(500).send({message: "Some error occurred while setting up the heatlh check."});
        }
     }
       });
       reportingApp.post('/api/reporting/permission-summary/setup',authMiddleware, async (req, res) =>  {    
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
        
        // First we get all the permission summaries in our database and check if there is an exisiting permission summary with
        // our companyId
        const document = database.collection('permission-summary');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissionSummaries =list;
        
        let filteredList=[];   
        permissionSummaries.forEach(obj => {
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
                message: 'Company Permission Summary Already Has An Initial Instance',
            });
    
        }
        else
        {
            
          //company was never registered before so we setup their permission summary table
          let permissionSummaryId = "PMSN-" + uuid.v4();
          let timestamp = new Date().today() + " @ " + new Date().timeNow();
          let month= timestamp.charAt(3)+timestamp.charAt(4);
          let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
    
          let permissionSummary = {
            permissionSummaryId: permissionSummaryId,
            month: month,
            year:year,
            timestamp: timestamp,
            companyId: reqJson.companyId,
            numPermissionDeniedUsers: 0,
            numPermissionDeniedVisitors: 0,
            numPermissionGrantedUsers: 0,
            numPermissionGrantedVisitors: 0,
            totalPermissions:0
              
            }
            try{
            await database.collection('permission-summary').doc(permissionSummaryId)
              .create(permissionSummary);
            
            return res.status(200).send({
                message: 'Company Permission Summary Successfuly Set',
                data:permissionSummary
            });
        } catch (error) {
            console.log(error);
            return res.status(500).send({message: "Some error occurred while setting up the heatlh check."});
        }
        
        }
    });

/**
 * @swagger
 * /reporting/summary-shifts:
 *   post:
 *     description: retrieve all shift summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */  
    reportingApp.post('/api/reporting/summary-shifts', async (req, res) =>  {    
        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
            const document = database.collection('summary-shifts').where("companyId", "==", companyId);
            const snapshot = await document.get();
      
            let list = [];
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
            
    
        let getNumberShift = list;
          
        if (getNumberShift != null) {
          return res.status(200).send({
            message: 'Successfully retrieved number of shifts',
            data: getNumberShift
          });
        } else {
          return res.status(500).send({message: "Some error occurred while fetching number of shifts."});
        }
    });

/**
 * @swagger
 * /reporting/summary-bookings:
 *   post:
 *     description: retrieve all bookings summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    reportingApp.post('/api/reporting/summary-bookings', async (req, res) =>  {    

        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
            const document = database.collection('summary-bookings').where("companyId", "==", companyId);
            const snapshot = await document.get();
      
            let list = [];
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
               
        let getNumberBooking = list;
          
        if (getNumberBooking != null) {
          return res.status(200).send({
            message: 'Successfully retrieved number of bookings',
            data: getNumberBooking
          });
        } else {
          return res.status(500).send({message: "Some error occurred while fetching number of bookings."});
        }
    });

/**
 * @swagger
 * /reporting/health-summary:
 *   post:
 *     description: retrieve all health summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    reportingApp.post('/api/reporting/health-summary',async (req, res) =>  {    
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
    
          const document = database.collection('health-summary');
          const snapshot = await document.get();
          
          let list = [];
          
          snapshot.forEach(doc => {
              let data = doc.data();
              list.push(data);
          });
      
    
        let healthSummaries = list;
        
        let filteredList=[];   
        healthSummaries.forEach(obj => {
        if(obj.companyId===reqJson.companyId && reqJson.month===obj.month && reqJson.year==obj.year)
              {
                filteredList.push(obj);
              }
              else
              {
        
              }
            });
        
            if(filteredList.length>0)
            {
                return res.status(200).send({
                    message: 'Successfully retrieved health summary',
                    data: filteredList
                });
           
             }
            else{
                return res.status(500).send({
                    message: 'Problem with either the companId,month or year you requesting for',
                });
            }
    
    });

/**
 * @swagger
 * /reporting/permission-summary:
 *   post:
 *     description: retrieve all permission summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    reportingApp.post('/api/reporting/permission-summary',async (req, res) =>  {    

        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          
            const document = database.collection('permission-summary');
            const snapshot = await document.get();
            
            let list = [];
            
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
    
        let permissionSummaries = list;
        
        let filteredList=[];   
        permissionSummaries.forEach(obj => {
        if(obj.companyId===reqJson.companyId && reqJson.month===obj.month && reqJson.year==obj.year)
              {
                filteredList.push(obj);
              }
              else
              {
        
              }
            });
        
            if(filteredList.length>0)
            {
                return res.status(200).send({
                    message: 'Successfully retrieved permission summary',
                    data: filteredList
                });
           
             }
            else{
                return res.status(500).send({
                    message: 'Problem with either the companId,month or year you requesting for',
                });
            }
    
    });

/**
 * @swagger
 * /reporting/company/users-data:
 *   post:
 *     description: create user data summary
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    reportingApp.post('/api/reporting/company/users-data',async (req, res) =>  {    

        // get total users
        const document = database.collection('users');
        const snapshot = await document.get();
        
        let counter = 0;
        
        snapshot.forEach(doc => {
            let data = doc.data();
            counter++;
        });
   
        let totalUsers = counter;
        totalUsers = totalUsers.toString();
    
        // get total employees
        const documen = database.collection('users').where("type","==", "Admin"); // or "ADMIN"
        const snapsho = await documen.get();
        
        let count = 0;
        
        snapsho.forEach(doc => {
            let data = doc.data();
            //console.log(counter);
            count++;
        });
        

        
        let totalemployees = count;
        totalemployees = totalemployees.toString();

    
        // get total admins
        const documents = database.collection('users').where("type","==", "Admin"); // or "ADMIN"
        const snapshots = await documents.get();
        
        let counters = 0;
        
        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(counter);
            counters++;
        });
       
        let totalAdmins = counters;
        totalAdmins = totalAdmins.toString();
    
        let usersDataId = "UD-" + uuid.v4();
    
        let usersData = {
            usersDataId: usersDataId,
            totalRegisteredUsers: totalUsers,
            totalEmployees: totalemployees,
            totalAdmins: totalAdmins
        }


        const documentd = database.collection('users-data');
        const snapshotd = await documentd.get();
        
        let list = [];
        
        snapshotd.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
            
        let result2 = list;
    
        if (result2.length > 0) // check if entry already exists in db table
        {
            const docume = database.collection('users-data').doc(result2[0].usersDataId); //or db.collection().where()

            await docume.update({
                totalRegisteredUsers: totalUsers
            });
              
            const docs = database.collection('users-data').doc(result2[0].usersDataId); //or db.collection().where()

            await docs.update({
            totalAdmins: totalAdmins
        });

        const d = database.collection('users-data').doc(result2[0].usersDataId); //or db.collection().where()

        await d.update({
            totalEmployees:totalemployees 
        });    
    
            let usersData = {
                usersDataId: result2[0].usersDataId,
                totalRegisteredUsers: totalUsers,
                totalEmployees: totalEmployees,
                totalAdmins: totalAdmins
            }
    
            return res.status(200).send({
                message: 'Users data successfully updated',
                data: usersData
            });
        }
        else
        {

            try{
            
            await database.collection('users-data').doc(usersData.usersDataId)
            .create(usersData);
            return res.status(200).send({
                message: 'Users data successfully created',
                data: usersData
             });
            } catch (error) {
                console.log(error);
                  return res.status(500).send({
                      message: '500 Server Error: DB error',
                      error: error
                  });
              }
        }   
});
    

    
/**
 * @swagger
 * /reporting/company/user-data/view:
 *   post:
 *     description: retrieve all user data summaries
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
    reportingApp.post('/reporting/company/users-data/view',async (req, res) =>  {    
       
            const document = database.collection('users-data');
            const snapshot = await document.get();
            
            let list = [];
            
            snapshot.forEach(doc => {
                let data = doc.data();
                list.push(data);
            });
         
        let result=list;


        if (!result) {
            return res.status(500).send({
                message: '500 Server Error: DB error',
            });
        }
    
        return res.status(200).send({
            message: 'Successfully retrieved users data',
            data: result
        });
    });
    




    
    
    

            

    
     








    





exports.reporting = functions.https.onRequest(reportingApp);
  
