let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let reportingApp = express();
//var serviceAccount = require("./permissions.json");
const authMiddleware = require('../authMiddleWare.js');

reportingApp.use(cors({ origin: true }));
reportingApp.use(express.urlencoded({ extended: true }));
reportingApp.use(express.json());
//admin.initializeApp(); 


let database = admin.firestore();
let uuid = require("uuid");


reportingApp.post('/api/reporting/health/sick-employees', async (req, res) =>  {
   
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

    let sickEmployeeId = "SCK-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let sickEmployeeData = {
        sickEmployeeId: sickEmployeeId,
        userId: reqJson.userId,
        userEmail: reqJson.userEmail,
        timeOfDiagnosis: timestamp,
        companyId: reqJson.companyId
    }

    try {
        await database.collection('sick-employees').doc(sickEmployeeId)
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
    





exports.reporting = functions.https.onRequest(reportingApp);
  
