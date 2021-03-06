let functions = require("firebase-functions");
let admin = require('firebase-admin');
let express = require('express');
let cors = require('cors');
let healthApp = express();
const authMiddleware = require('../authMiddleWare.js');

healthApp.use(cors({ origin: true }));
healthApp.use(express.urlencoded({ extended: true }));
healthApp.use(express.json());

let database = admin.firestore();
let uuid = require("uuid");
var nodemailer = require('nodemailer');

//////////////////////////////////////////////////////////////////GENERAL FUNCTIONS AND OBJECTS/////////////////////////////////////////////////

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




  async function hasHighTemperature (temparature) {
    //temperature is 36-37 degrees celsius
    //we use celsius because most screening instuments available in south africa are available in celsius temperature measure
    let temp=parseFloat(temparature);
    let acceptableTemp=parseFloat('37.5');
    if(temp>acceptableTemp)
    {
        return true;
    }
    else
    {
      return false;
    }
  }
  
  async function getPredictionResult(d_t_prediction,dt_accuracy,naive_prediction,nb_accuracy){
    //in this case we are using 2 models for predictions and we should weigh their results
    if((d_t_prediction==="positive") && (naive_prediction==="positive"))// if the models both predicted the same then we can return the results
    {
      return true;
    }
    else if((d_t_prediction==="negative") && (naive_prediction==="negative"))
    {
      return false;
    }
    else if((d_t_prediction==="negative") && (naive_prediction==="positive"))
    {
        let dtAccuracy=parseFloat(dt_accuracy);
        let nbAccuracy=parseFloat(naive_prediction);
        if(dtAccuracy>nbAccuracy)
        {
          return false;
        }
        else if(dtAccuracy<nbAccuracy)
        {
          return true;
        }
        else if(dtAccuracy===nbAccuracy)
        {
          //favour decision tree algorith over naive bais
            return false;
        }
  
    }
    else if((d_t_prediction==="positive") && (naive_prediction==="negative"))
    {
        let dtAccuracy=parseFloat(dt_accuracy);
        let nbAccuracy=parseFloat(naive_prediction);
        if(dtAccuracy>nbAccuracy)
        {
          return true;
        }
        else if(dtAccuracy<nbAccuracy)
        {
          return false;
        }
        else if(dtAccuracy===nbAccuracy)
        {
          //favour decision tree algorith over naive bais
            return true;
        }
  
    }
    else
    {
      return false;
    }
    
  
  
  }

  /**
 * This function sends an email to a user using the users email address
 * The function is used as an internal service to other functions 
 * @param receiver The reciever  may not be null.
 * @param subject The subject  may not be null.
 * @param message The message  may not be null.
 */
async function sendUserEmail(receiver,subject,message){
    var transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'capslock.cos301@gmail.com',
          pass: 'Coviduous.COS301'
        }
      });
      
      var mailOptions = {
        from: 'capslock.cos301@gmail.com',
        to: receiver,
        subject: subject,
        text: message
      };
      
      transporter.sendMail(mailOptions, function(error, info){
        if (error) {
          console.log(error);
        } else {
          console.log('Email sent: ' + info.response);
          return true;
        }
      }); 
 }

  async function permissionDeniedBadge (userId,userEmail) {
        let permissionId = "PRMN-" + uuid.v4();
        let timestamp =new Date().today() + " @ " + new Date().timeNow();
        let acessPermission=false;
        let authorizedBy="SYSTEM";
  
        let permissionData = {
          permissionId: permissionId,
          userId:userId,
          userEmail:userEmail,
          timestamp: timestamp,
          officeAccess: acessPermission,
          grantedBy:authorizedBy
        }
    
        try {
          await database.collection('permissions').doc(permissionId).create(permissionData);
          await sendUserEmail(userEmail,"ACCESS TO OFFICE DENIED","BASED ON YOUR HEALTH ASSESSMENT YOU HAVE BEEN DENIED OFFICE ACCESS PLEASE CONTACT YOUR ADMINISTRATOR FOR A REVIEW");
          console.log(permissionData);
          return true;
            
        } catch (error) {
            return false;
            
        }
        
  }
  
  async function permissionAcceptedBadge(userId,userEmail) {
    let permissionId = "PRMN-" + uuid.v4();
    let timestamp =new Date().today() + " @ " + new Date().timeNow();
    let acessPermission=true;
    let authorizedBy="SYSTEM";
  
    let permissionData = {
      permissionId: permissionId,
      userId:userId,
      userEmail:userEmail,
      timestamp: timestamp,
      officeAccess: acessPermission,
      grantedBy:authorizedBy
    }
    
    try {
        await database.collection('permissions').doc(permissionId).create(permissionData);
        await sendUserEmail(userEmail,"ACCESS TO OFFICE GRANTED","BASED ON YOUR HEALTH ASSESSMENT YOU HAVE BEEN GRANTED OFFICE ACCESS.");
        console.log(permissionData);
        return true;
          
      } catch (error) {
          return false;
          
      }

  }

//////////////////////////////////////////////////////////////////GENERAL FUNCTIONS AND OBJECTS/////////////////////////////////////////////////
///////////////// HEALTH CHECK /////////////////
/**
 * @swagger
 * /health/health-check:
 *   post:
 *     description: create a health check
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/health-check', authMiddleware,async (req, res) => {

    let fieldErrors = [];
  
    if (req == null) {
      fieldErrors.push({field: null, message: 'Request object may not be null'});
    }
  
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
  
    if (reqJson.name == null || reqJson.name === '') {
      fieldErrors.push({field: 'name', message: 'Name of individual may not be empty'});
    }
  
    if (reqJson.surname == null || reqJson.surname === '') {
      fieldErrors.push({field: 'surname', message: 'Surname of individual may not be empty'});
    }
  
    if (reqJson.email == null || reqJson.email === '') {
      fieldErrors.push({field: 'email', message: 'email of individual may not be empty'});
    }
  
    if (reqJson.phoneNumber == null || reqJson.phoneNumber === '') {
      fieldErrors.push({field: 'phone number', message: 'phone number may not be empty'});
    }
    
    if (reqJson.temperature == null || reqJson.temperature === '') {
      fieldErrors.push({field: 'temperature', message: 'temperature number may not be empty'});
    }
  
    if (fieldErrors.length > 0) {
      console.log(fieldErrors);
      return res.status(400).send({
        message: '400 Bad Request: Incorrect fields',
        errors: fieldErrors
      });
    }
  
    try {
      let healthCheckId = "HTH-" + uuid.v4();
      //add a time attribute
  
      let healthCheckData = {
        healthCheckId: healthCheckId,
        userId: reqJson.userId,
        name: reqJson.name,
        surname: reqJson.surname,
        email: reqJson.email,
        phoneNumber: reqJson.phoneNumber,
        temperature: reqJson.temperature,
        fever: reqJson.fever,
        cough: reqJson.cough,
        sore_throat: reqJson.sore_throat,
        chills: reqJson.chills,
        aches: reqJson.aches,
        nausea: reqJson.nausea,
        shortness_of_breath: reqJson.shortness_of_breath,
        loss_of_taste: reqJson.loss_of_taste,
        six_feet_contact: reqJson.six_feet_contact,
        tested_positive: reqJson.tested_positive,
        travelled: reqJson.travelled,
        age60_and_above:reqJson.age60_and_above,
        gender:reqJson.gender
      }
      //assess temparature first and if temparature is above covid19 threshold issue a permission not granted
      let highTemp= await hasHighTemperature(reqJson.temperature);
      console.log(highTemp);
      // Prediction to external AI service is anonymous, we donot send out personal infromation to the external service
      // personal information eg. name,surname,phone numbers are not sent but only symptoms and and history of contact 
      //is used to make a prediction
       // if temparature is less than threshold evaluate the AI prediction and accuracy score
      let AIprediction=await getPredictionResult(reqJson.d_t_prediction,reqJson.dt_accuracy,reqJson.naive_prediction,reqJson.nb_accuracy);
      console.log(AIprediction);
      if(highTemp==true)
      {
        await permissionDeniedBadge(reqJson.userId,reqJson.email);
        try {
            await database.collection('health-check').doc(healthCheckData.healthCheckId).create(healthCheckData);
        } catch (error) {
            console.log(error);
        }
        return res.status(200).send({
          message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
          data: healthCheckData
        });
      }
      else if(AIprediction==true)
      {
        //if prediction is positive issue out a permission denied
        await permissionDeniedBadge(reqJson.userId,reqJson.email);
        try {
            await database.collection('health-check').doc(healthCheckData.healthCheckId).create(healthCheckData);
        } catch (error) {
            console.log(error);
        }
        ////////////////////////////////////////////////////////////////////////////////////////
        // update the health summary collection
        // first check if the current month and year you are currently in is registered
  
        let healthSummaryId = "HSID-" + uuid.v4();
        let permissionSummaryId = "PMSN-" + uuid.v4();
        let timestamp = new Date().today() + " @ " + new Date().timeNow();
        let month= timestamp.charAt(3)+timestamp.charAt(4);
        let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
        //////
        let document = database.collection('health-summary');
        let snapshot = await document.get();
        let healthSummaries = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            healthSummaries.push(data);
        });
        /////
        document = database.collection('permission-summary');
        snapshot = await document.get();
        let permissionSummaries = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            permissionSummaries.push(data);
        });
      ///////
      let filteredList=[];  
      let filteredList2=[]; 
      healthSummaries.forEach(obj => {
      if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
            {
              filteredList.push(obj);
            }
            else
            {
      
            }
          });
      permissionSummaries.forEach(obj => {
        if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
              {
                filteredList2.push(obj);
              }
              else
              {
        
              }
            });
  
      if(filteredList.length>0)
      {
          // company was previously initialized no need to re-initilize
          // we can perform an update on the healthcheck field
          if(reqJson.userId==="VISITOR")
          {
            let numHealthChecksVisitors=parseInt(filteredList[0].numHealthChecksVisitors) + 1;
            //updateHealthSummaryVisitor
            try {
                response= await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
                {
                  numHealthChecksVisitors:numHealthChecksVisitors
                }
                );
                
              } catch (error) {
                console.log(error);
              }
  
          }
          else
          {

            let numHealthChecksUsers=parseInt(filteredList[0].numHealthChecksUsers) + 1;

            try{
                await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
                {
                  numHealthChecksUsers:numHealthChecksUsers
                }
                );
                
              } catch (error) {
                console.log(error);
              }
  
          }
          
  
      }
      else
      {
        // The year and the month for this company is not registered
        //initialize a new month or year for this company and set its initial values
  
          if(reqJson.userId==="VISITOR")
          {
            let healthSummary = {
              healthSummaryId: healthSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numHealthChecksUsers: 0,
              numHealthChecksVisitors: 1,
              numReportedInfections: 0,
              numReportedRecoveries:0
                
              }
              await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
            
          }
          else
          {
  
            let healthSummary = {
              healthSummaryId: healthSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numHealthChecksUsers: 1,
              numHealthChecksVisitors: 0,
              numReportedInfections: 0,
              numReportedRecoveries:0
                
              }
              await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
            
  
          }
      }
      //////////////////////////////////////////////////////////
      if(filteredList2.length>0)
      {
          // company was previously initialized no need to re-initilize
          // we can perform an update on the numPermissionDeniedVisitors field
      
          if(reqJson.userId==="VISITOR")
          {
            //console.log("permission denied VISITOR");
            let numPermissionDeniedVisitors=parseInt(filteredList2[0].numPermissionDeniedVisitors) + 1;
            let totalPermissions=parseInt(filteredList2[0].totalPermissions) + 1;

            try {
                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                  totalPermissions:totalPermissions
                }
                );

                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                    numPermissionDeniedVisitors:numPermissionDeniedVisitors,
                    numPermissionDeniedUsers:6
                }
                );
                
              } catch (error) {
                console.log(error);
              }
          }
          else
          {
            let numPermissionDeniedUsers=parseInt(filteredList2[0].numPermissionDeniedUsers) + 1;
            let totalPermissions=parseInt(filteredList2[0].totalPermissions) + 1;

            try {
                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                  totalPermissions:totalPermissions
                }
                );

                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                  numPermissionDeniedUsers:numPermissionDeniedUsers
                }
                );
                
              } catch (error) {
                console.log(error);
              }
            
          }
          
      }
      else
      {
        // The year and the month for this company is not registered
        //initialize a new month or year for this company and set its initial values
  
          if(reqJson.userId==="VISITOR")
          {
            let permissionSummary = {
              permissionSummaryId: permissionSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numPermissionDeniedUsers: 0,
              numPermissionDeniedVisitors: 1,
              numPermissionGrantedUsers: 0,
              numPermissionGrantedVisitors: 0,
              totalPermissions:1
                
              }
            await database.collection('permission-summary').doc(permissionSummaryId).create(permissionSummary);
            
          }
          else
          {
  
            let permissionSummary = {
              permissionSummaryId: permissionSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numPermissionDeniedUsers: 1,
              numPermissionDeniedVisitors: 0,
              numPermissionGrantedUsers: 0,
              numPermissionGrantedVisitors: 0,
              totalPermissions:1
                
              }

            await database.collection('permission-summary').doc(permissionSummaryId).create(permissionSummary);
  
          }
        }
      /////////
      /////////////////////////////////////////////////////////////////////////////
        return res.status(200).send({
          message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
          data: healthCheckData
        });
  
      }
      else
      {
        //if prediction is negative and temparature is low we can offer a permissions granted badge
        // all healthchecks are saved into the database for reporting
        await permissionAcceptedBadge(reqJson.userId,reqJson.email);
        try {
            await database.collection('health-check').doc(healthCheckData.healthCheckId).create(healthCheckData);
        } catch (error) {
            console.log(error);
        }
        ////////////////////////////////////////////////////////////////////////////////////////
        // update the health check summary collection
        // first check if the current month and year you are currently in is registered
  
        let healthSummaryId = "HSID-" + uuid.v4();
        let permissionSummaryId = "PMSN-" + uuid.v4();
        let timestamp = new Date().today() + " @ " + new Date().timeNow();
        let month= timestamp.charAt(3)+timestamp.charAt(4);
        let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
        //////
        let document = database.collection('health-summary');
        let snapshot = await document.get();
        let healthSummaries = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            healthSummaries.push(data);
        });
        /////
        document = database.collection('permission-summary');
        snapshot = await document.get();
        let permissionSummaries = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            permissionSummaries.push(data);
        });
      ///////
      
      let filteredList=[];
      let filteredList2=[];   
      healthSummaries.forEach(obj => {
      if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
            {
              filteredList.push(obj);
            }
            else
            {
      
            }
          });
      permissionSummaries.forEach(obj => {
        if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
              {
                filteredList2.push(obj);
              }
              else
              {
        
              }
            });
  
      if(filteredList.length>0)
      {
          // company was previously initialized no need to re-initilize
          // we can perform an update on the healthcheck field
          if(reqJson.userId==="VISITOR")
          {
            let numHealthChecksVisitors=parseInt(filteredList[0].numHealthChecksVisitors) + 1;
            //updateHealthSummaryVisitor
            try {
                await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
                {
                  numHealthChecksVisitors:numHealthChecksVisitors
                }
                );
                
              } catch (error) {
                console.log(error);
              }

          }
          else
          {
            let numHealthChecksUsers=parseInt(filteredList[0].numHealthChecksUsers) + 1;
            //updateHealthSummaryVisitor
            try {
                await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
                {
                    numHealthChecksUsers:numHealthChecksUsers
                }
                );
                
              } catch (error) {
                console.log(error);
              }
  
          }
          
  
      }
      else
      {
        // The year and the month for this company is not registered
  
          if(reqJson.userId==="VISITOR")
          {
            let healthSummary = {
              healthSummaryId: healthSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numHealthChecksUsers: 0,
              numHealthChecksVisitors: 1,
              numReportedInfections: 0,
              numReportedRecoveries:0
                
              }
              await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
            
          }
          else
          {
  
            let healthSummary = {
              healthSummaryId: healthSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numHealthChecksUsers: 1,
              numHealthChecksVisitors: 0,
              numReportedInfections: 0,
              numReportedRecoveries:0
                
              }
              await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
            
  
          }
      }
      //////////////////////////////////////////////////////////
      if(filteredList2.length>0)
      {
          // company was previously initialized no need to re-initilize
          // we can perform an update on the numPermissionAccepted field
          if(reqJson.userId==="VISITOR")
          {
            let numPermissionGrantedVisitors=parseInt(filteredList2[0].numPermissionGrantedVisitors) + 1;
            let totalPermissions=parseInt(filteredList2[0].totalPermissions) + 1;

            try {
                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                  totalPermissions:totalPermissions
                }
                );

                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                    numPermissionGrantedVisitors:numPermissionGrantedVisitors
                }
                );
                
              } catch (error) {
                console.log(error);
              }
          }
          else
          {
            let numPermissionGrantedUsers=parseInt(filteredList2[0].numPermissionGrantedUsers) + 1;
            let totalPermissions=parseInt(filteredList2[0].totalPermissions) + 1;

            try {
                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                  totalPermissions:totalPermissions
                }
                );

                await database.collection('permission-summary').doc(filteredList2[0].permissionSummaryId).update(
                {
                    numPermissionGrantedUsers:numPermissionGrantedUsers
                }
                );
                
              } catch (error) {
                console.log(error);
              }
          }
          
  
      }
      else
      {
        // The year and the month for this company is not registered
        //initialize a new month or year for this company and set its initial values
  
          if(reqJson.userId==="VISITOR")
          {
            let permissionSummary = {
              permissionSummaryId: permissionSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numPermissionDeniedUsers: 0,
              numPermissionDeniedVisitors: 0,
              numPermissionGrantedUsers: 0,
              numPermissionGrantedVisitors: 1,
              totalPermissions:1
                
              }
              await database.collection('permission-summary').doc(permissionSummaryId).create(permissionSummary);
            
          }
          else
          {
  
            let permissionSummary = {
              permissionSummaryId: permissionSummaryId,
              month: month,
              year:year,
              timestamp: timestamp,
              companyId: reqJson.companyId,
              numPermissionDeniedUsers: 0,
              numPermissionDeniedVisitors: 0,
              numPermissionGrantedUsers: 1,
              numPermissionGrantedVisitors: 0,
              totalPermissions:1
                
              }
              await database.collection('permission-summary').doc(permissionSummaryId).create(permissionSummary);
            
  
          }
        }
      /////////
        return res.status(200).send({
          message: 'Health Check Successfully Created , Access Granted',
          data: healthCheckData
        });
  
      }
  
      
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
  });
////////////////////////////////////////////////////////////////////////////////////////////
///////////////// PERMISSION /////////////////
/**
 * @swagger
 * /health/permissions/view:
 *   post:
 *     description: retrieve all office access permissions by user email
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/permissions/view', authMiddleware,async (req, res) => {
  try {
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let document = database.collection('permissions').orderBy("timestamp");//.where("userEmail", "==", reqJson.userEmail);
      let snapshot = await document.get();
        
      let permissions = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            //permissions.push(data);

            if (data.userEmail == reqJson.userEmail)
            {
              permissions.push(data);
            }
        });
      
      return res.status(200).send({
        message: 'Successfully retrieved permissions',
        data: permissions
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching permissions."
      });
  }
});


///////////////// PERMISSION REQUEST /////////////////
/**
 * @swagger
 * /health/permissions/permission-request:
 *   post:
 *     description: create a permission request
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */

healthApp.post('/api/health/permissions/permission-request',authMiddleware,async (req, res) => {
  try {
    let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
    let permissionRequestId = "PR-" + uuid.v4();
    let timestamp = new Date().today() + " @ " + new Date().timeNow();

    let permissionRequestData = {
      permissionRequestId: permissionRequestId,
      permissionId:reqJson.permissionId,
      userId: reqJson.userId,
      userEmail:reqJson.userEmail,
      shiftNumber: reqJson.shiftNumber,
      timestamp: timestamp,
      reason: reqJson.reason,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId,
    }

    await database.collection('permission-requests').doc(permissionRequestId).create(permissionRequestData);
      let notificationId = "NTFN-" + uuid.v4();
      timestamp = new Date().today() + " @ " + new Date().timeNow();

      let notificationData = {
        notificationId: notificationId,
        userId: reqJson.userId,
        userEmail:reqJson.userEmail,
        subject: "PERMISSION REQUEST",
        message: "EMPLOYEE : "+reqJson.userId+" WITH EMAIL : "+reqJson.userEmail+" REQUESTS OFFICE ACCESS",
        timestamp: timestamp,
        adminId: reqJson.adminId,
        companyId: reqJson.companyId
      }
  
      await database.collection('notifications').doc(notificationId).create(notificationData);
      await sendUserEmail(reqJson.adminEmail,notificationData.subject,notificationData.message);
      return res.status(200).send({
        message: 'Permission request successfully created',
        data: permissionRequestData
      });

  } catch (error) {
      console.log(error);
      return res.status(500).send(error);
  }
});

//////////////////////////////
/**
 * @swagger
 * /health/permissions/permission-request/view:
 *   post:
 *     description: retrieve all permission requests by companyId
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/permissions/permission-request/view', authMiddleware,async (req, res) => {
  try {
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let document = database.collection('permission-requests').where("companyId", "==", reqJson.companyId);
      let snapshot = await document.get();
        
        let permissionRequests = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            permissionRequests.push(data);
        });
      
      return res.status(200).send({
        message: 'Successfully retrieved permission requests',
        data: permissionRequests
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching permission requests."
      });
  }
});

///////////////////////////////////
/**
 * @swagger
 * /health/permissions/permission-request/grant:
 *   post:
 *     description: grant a permission request
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/permissions/permission-request/grant',authMiddleware,async (req, res) => {
  try {

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let notificationId = "NTFN-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();

      await database.collection('permissions').doc(reqJson.permissionId).update(
        {
            grantedBy:"ADMIN",
            officeAccess:true
        }
        );
      let notificationData = {
        notificationId: notificationId,
        userId: reqJson.userId,
        userEmail:reqJson.userEmail,
        subject: "ACCESS PERMISSION",
        message: "OFFICE ACCESS PERMISSION UPDATED, PERMISSION GRANTED",
        timestamp: timestamp,
        adminId: reqJson.adminId,
        companyId: reqJson.companyId
      }
  
      await database.collection('notifications').doc(notificationId).create(notificationData);
      await sendUserEmail(notificationData.userEmail,notificationData.subject,notificationData.message);
      return res.status(200).send({
        message: 'Successfully updated the permission requests',
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching permission requests."
      });
  }
});

///////////////////////////////////////
/**
 * @swagger
 * /health/report-infection:
 *   post:
 *     description: create a reported infection
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
*/
healthApp.post('/api/health/report-admins',authMiddleware,async (req,res)=>{
  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  console.log(reqJson);

  if (reqJson.companyId == null || reqJson.companyId === '') {
    fieldErrors.push({field: 'companyId', message: 'companyId may not be empty'});
}
  
  const documents = database.collection('users').where("companyId","==",reqJson.companyId);
  const snapshots = await documents.get();

  let list =[];
  let listd=[];
   snapshots.forEach(doc => {
       let data = doc.data();
       listd.push(data);
   });

   for (const element of listd) {
     if(element.type==="ADMIN")
      {
        list.push(element);
      }
  }
  
  if(list==null){
    return res.status(200).send({//////////
      message: 'Admin email does not exits'
    });
  }
else{
  return res.status(200).send({
    message: 'Successfully retrieved admins',
    data: list
  });
}

});

///////////////////////////////////////
healthApp.post('/api/health/report-infection',authMiddleware,async (req, res) => {
  try {

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    
      let infectionId = "INF-" + uuid.v4();
      let notificationId = "NTFN-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let reportedInfectionData = {
      infectionId: infectionId,
      userId: reqJson.userId,
      userEmail:reqJson.userEmail,
      timestamp: timestamp,
      adminId:reqJson.adminId,
      companyId: reqJson.companyId
    }
        let notificationData = {
      notificationId: notificationId,
      userId: reqJson.userId,
      userEmail:reqJson.userEmail,
      subject: "COVID-19 INFECTION",
      message: "EMPLOYEE  ID :"+reqJson.userId+" EMAIL: "+reqJson.userEmail+" REPORTED A POSITIVE COVID-19 CASE",
      timestamp: timestamp,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId
    }

    await database.collection('notifications').doc(notificationData.notificationId).create(notificationData);
    await database.collection('reported-infections').doc(infectionId).create(reportedInfectionData);
    await sendUserEmail(reqJson.adminEmail,notificationData.subject,notificationData.message);

     ////////////////////////////////////////////////////////////////////////////////////////
      // update the health check summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let document = database.collection('health-summary');
      let snapshot = await document.get();
      
      let healthSummaries = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          healthSummaries.push(data);
      });
    
    let filteredList=[];   
    healthSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
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
        // we can perform an update on the healthcheck field
          let numReportedInfections=filteredList[0].numReportedInfections;
          numReportedInfections++;

          await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
            {
              numReportedInfections:numReportedInfections
            }
            );

        

    }
    else
    {
      // The year and the month for this company is not registered

          let healthSummary = {
            healthSummaryId: healthSummaryId,
            month: month,
            year:year,
            timestamp: timestamp,
            companyId: reqJson.companyId,
            numHealthChecksUsers: 0,
            numHealthChecksVisitors: 0,
            numReportedInfections: 1,
            numReportedRecoveries:0
              
            }
            await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
          

        
    }
    /////////////////////////////////////////////////////////////////////////////
      
      return res.status(200).send({
        message: 'Successfully reported infection',
        data: true
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while reporting infection."
      });
  }
});

//////////////////////////////////////////
/**
 * @swagger
 * /health/report-recovery:
 *   post:
 *     description: create a reported recovery
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 healthApp.post('/api/health/report-recovery',authMiddleware,async (req, res) => {
  try {

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let recoveryId = "RECV-" + uuid.v4();
      let notificationId = "NTFN-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
    let reportedRecoveryData = {
      recoveryId: recoveryId,
      userId: reqJson.userId,
      userEmail:reqJson.userEmail,
      timestamp: timestamp,
      adminId:reqJson.adminId,
      companyId: reqJson.companyId
    }

    let notificationData = {
      notificationId: notificationId,
      userId: reqJson.userId,
      userEmail:reqJson.userEmail,
      subject: "COVID-19 RECOVERY STATUS UPDATED",
      message: "EMPLOYEE  ID :"+reqJson.userId+" COVID-19 RECOVERY STATUS HAS BEEN UPDATED PLEASE PERFROM A NEW HEALTH ASSESSMENT",
      timestamp: timestamp,
      adminId: reqJson.adminId,
      companyId: reqJson.companyId
    }

    await database.collection('notifications').doc(notificationId).create(notificationData)
    
    await database.collection('reported-recoveries').doc(recoveryId).create(reportedRecoveryData);
    await sendUserEmail(reqJson.userEmail,notificationData.subject,notificationData.message);

     ////////////////////////////////////////////////////////////////////////////////////////
      // update the health check summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let document = database.collection('health-summary');
      let snapshot = await document.get();
      
      let healthSummaries = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          healthSummaries.push(data);
      });
    
    let filteredList=[];   
    healthSummaries.forEach(obj => {
    if(obj.companyId===reqJson.companyId && obj.month===month && obj.year==year)
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
        // we can perform an update on the healthcheck field
          let numReportedRecoveries=filteredList[0].numReportedRecoveries;
          numReportedRecoveries++;

          await database.collection('health-summary').doc(filteredList[0].healthSummaryId).update(
            {
              numReportedRecoveries:numReportedRecoveries
            }
            );

        

    }
    else
    {
      // The year and the month for this company is not registered

          let healthSummary = {
            healthSummaryId: healthSummaryId,
            month: month,
            year:year,
            timestamp: timestamp,
            companyId: reqJson.companyId,
            numHealthChecksUsers: 0,
            numHealthChecksVisitors: 0,
            numReportedInfections: 0,
            numReportedRecoveries:1
              
            }

            await database.collection('health-summary').doc(healthSummaryId).create(healthSummary);
          

        
    }
    /////////////////////////////////////////////////////////////////////////////
      
      return res.status(200).send({
        message: 'Successfully reported recovery',
        data: true
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while reporting recovery."
      });
  }
});

/////////////////////////////////////
//////////////////////////////////// Contact Tracing ///////////////////////////
///////////////
//returns a group of employees who fall under the same shift identified by the shiftId
/**
 * @swagger
 * /health/contact-trace/group:
 *   post:
 *     description: retrieve all contact trace groups by shiftId
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/contact-trace/group',authMiddleware,async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }

      let document = database.collection('groups');
      let snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            if(obj.shiftNumber===reqJson.shiftNumber)
            {
                group.push(obj);
            }
            else
            {
            }
          });
      
      return res.status(200).send({
        message: 'Successfully retrieved group',
        data: group
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching group."
      });
  }
});
////////////////////////////////////
//returns a shifts an employee was in based on the employee email
/**
 * @swagger
 * /health/contact-trace/shifts:
 *   post:
 *     description: retrieve all contact trace shifts by user email
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 healthApp.post('/api/health/contact-trace/shifts',authMiddleware,async (req, res) => {
  try {
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
      let document = database.collection('groups');
      let snapshot = await document.get();
        
        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data);
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            for (var i = 0; i < obj.userEmails.length; i++) {
                if (obj.userEmails[i] === reqJson.userEmail) {
                    group.push(obj);
                }
            }
        });
        
        document = database.collection('shifts');
        snapshot = await document.get();
  
        let shifts = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            shifts.push(data);
        });

        let userShifts=[];
        group.forEach(obj => {
            shifts.forEach(obj2 => {
            if(obj2.shiftID===obj.shiftNumber) {
                userShifts.push(obj2);
            }});
        });
      
      return res.status(200).send({
        message: 'Successfully retrieved shifts',
        data: userShifts
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching shifts."
      });
  }
});
////////////////////////////////////
/**
 * @swagger
 * /health/permissions:
 *   delete:
 *     description: delete a permission request
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.delete('/health/permissions',authMiddleware, async (req, res)=>{
  try{
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    
      let document = database.collection('permission-requests').doc(reqJson.permissionRequestId);
      await document.delete();
          return res.status(200).send({
          message: 'Successfully Deleted permissionRequest',
        });
  }catch(error){
    console.log(error);
    return res.status(500).send({
  
    });
  }
  
  });
////////////////////////////////////
/**
 * @swagger
 * /health/contact-trace/notify-group:
 *   post:
 *     description: send notification email to a shift group by shiftId
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/contact-trace/notify-group',authMiddleware,async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
    console.log(reqJson);
      let document = database.collection('groups');
      let snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            if(obj.shiftNumber===reqJson.shiftNumber)
            {
                group.push(obj);
            }
            else
            {
            }
          });
      group.forEach(obj => {
          for (let i = 0; i < obj.userEmails.length; i++) {
              let notificationId = "NTFN-" + uuid.v4();
              let timestamp = new Date().today() + " @ " + new Date().timeNow();

              let notificationData = {
                  notificationId: notificationId,
                  userId: "",
                  userEmail:obj.userEmails[i],
                  subject: "COVID-19 CONTACT RISK",
                  message: "YOU MAY HAVE BEEN IN CLOSE CONTACT WITH SOMEONE WHO HAS COVID-19, PLEASE CONTACT THE HEALTH SERVICES AND YOUR ADMINISTRATOR",
                  timestamp: timestamp,
                  adminId: obj.adminId,
                  companyId: ""
          }
          database.collection('notifications').doc(notificationId).create(notificationData)
          sendUserEmail(notificationData.userEmail,notificationData.subject,notificationData.message);
        }
      });
      
      return res.status(200).send({
        message: 'Successfully notified group members',
        data: group
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching group."
      });
  }
});
////////////////////////////////////////////////////////
/**
 * @swagger
 * /health/Covid19TestResults:
 *   post:
 *     description: upload COVID-19 test results document
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */

healthApp.post('/api/health/Covid19TestResults',authMiddleware, async (req, res) => {
  try {
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
      let documentId = "DOC-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();

      let documentData = {
          documentId: documentId,
          userId: reqJson.userId,
          fileName:reqJson.fileName,
          timestamp: timestamp,
          base64String: reqJson.base64String,
          
        }
        
        
        await database.collection('test-results').doc(documentId).create(documentData);
      return res.status(200).send({
        message: 'Successfully stored test results',
        data: documentData
      });
    
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while trying to store results."
      });
  }
});
///////////////////////////////////////
/**
 * @swagger
 * /health/Covid19VaccineConfirmation/view:
 *   post:
 *     description: retrieve all COVID-19 vaccine documents
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */

healthApp.post('/api/health/Covid19VaccineConfirmation/view',authMiddleware, async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }

      let filteredList=[];
      let document = database.collection('vaccine-confirmations');
      let snapshot = await document.get();
      
      let results = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          results.push(data);
      });
      
      results.forEach(obj => {
        if(obj.userId===reqJson.userId)
        {
          filteredList.push(obj);
        }
        else
        {
  
        }
      });
      return res.status(200).send({
        message: 'Successfully Fetched Documents.',
        data: filteredList
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching Documents."
      });
  }
  });
  //////////////////
  /**
 * @swagger
 * /health/Covid19TestResults/view:
 *   post:
 *     description: retrieve all COVID-19 test results documents
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  healthApp.post('/api/health/Covid19TestResults/view', authMiddleware,async (req, res) => {
    try {
        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }

        let filteredList=[];
        let document = database.collection('test-results');
        let snapshot = await document.get();
        
        let results = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            results.push(data);
        });
        
        results.forEach(obj => {
          if(obj.userId===reqJson.userId)
          {
            filteredList.push(obj);
          }
          else
          {
    
          }
        });
        return res.status(200).send({
          message: 'Successfully Fetched Documents.',
          data: filteredList
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
          message: error.message || "Some error occurred while fetching Documents."
        });
    }
    });
    //////////////////
    /**
 * @swagger
 * /health/Covid19VaccineConfirmation:
 *   post:
 *     description: upload COVID-19 vaccine document
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  healthApp.post('/api/health/Covid19VaccineConfirmation', authMiddleware,async (req, res) => {
      try {
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          let documentId = "DOC-" + uuid.v4();
          let timestamp = new Date().today() + " @ " + new Date().timeNow();
    
          let documentData = {
              documentId: documentId,
              userId: reqJson.userId,
              fileName:reqJson.fileName,
              timestamp: timestamp,
              base64String: reqJson.base64String,
              
            }
            await database.collection('vaccine-confirmations').doc(documentId).create(documentData); 
          return res.status(200).send({
            message: 'Successfully stored vaccine confirmation document',
            data: documentData
          });
      
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: error.message || "Some error occurred while storing vaccine document."
          });
      }
    });


    //////////////////
    /**
 * @swagger
 * /health/store-emails:
 *   post:
 *     description: stores emails fetched from broadcasted bluetooth devices
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  healthApp.post('/api/health/store-emails', authMiddleware, async (req, res) => {
    try {
      let fieldErrors = [];
  
    if (req == null) {
      fieldErrors.push({field: null, message: 'Request object may not be null'});
    }
      let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }
        if (reqJson.userId == null || reqJson.userId === '') {
          fieldErrors.push({field: 'user ID ', message: 'user ID may not be empty'});
        }
        
        if (reqJson.email_list == null || reqJson.email_list === '') {
          fieldErrors.push({field: 'email list', message: 'email list may not be empty'});
        }
      
        if (fieldErrors.length > 0) {
          console.log(fieldErrors);
          return res.status(400).send({
            message: '400 Bad Request: Incorrect fields',
            errors: fieldErrors
          });
        }
        let timestamp = new Date().today() + " @ " + new Date().timeNow();
  
        let contactData = {
            userId: reqJson.userId,
            email_list:reqJson.email_list,
            timestamp: timestamp
          }
          await database.collection('physical-contact-with').doc(reqJson.userId).set(contactData); 
        return res.status(200).send({
          message: 'Successfully stored list of people who employee was in contact with',
          data: contactData
        });
    
    } catch (error) {
        console.log(error);
        return res.status(500).send({
          message: error.message || "Some error occurred while storing list."
        });
    }
  });

  //////////////////
    /**
 * @swagger
 * /health/view-stored-emails:
 *   post:
 *     description: brings a list of emails fetched from broadcasted bluetooth devices
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
     healthApp.post('/api/health/view-stored-emails',authMiddleware,async (req, res) => {
      try {
        let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.userId == null || reqJson.userId === '') {
            fieldErrors.push({field: 'user ID ', message: 'user ID may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }
    
            let document = database.collection('physical-contact-with').where("userId", "==", reqJson.userId);
            let snapshot = await document.get();
            let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
            let contactData = list;
          return res.status(200).send({
            message: 'Successfully Fetched List',
            data: contactData
          });
      
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: error.message || "Some error occurred while fetching list."
          });
      }
    });


     //////////////////
    /**
 * @swagger
 * /health/view-stored-emails:
 *   post:
 *     description: brings a list of emails fetched from broadcasted bluetooth devices
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
  healthApp.post('/api/health/notify-contacted',authMiddleware, async (req, res) => {
      try {
        let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.userId == null || reqJson.userId === '') {
            fieldErrors.push({field: 'user ID ', message: 'user ID may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }
    
            let document = database.collection('physical-contact-with').where("userId", "==", reqJson.userId);
            let snapshot = await document.get();
            let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        let notificationData = {
          subject: "COVID-19 INFECTION",
          message: "EMPLOYEE  ID :"+reqJson.userId+" REPORTED A POSITIVE COVID-19 CASE AND MAY HAVE BEEN IN CONTACT WITH YOU PLEASE CONSULT YOUR ADMINISTRATOR OR HEALTH SERVICES",
          
        }

        if(list.length===0)
        {
          return res.status(200).send({
            message: 'Successfully Fetched List,But no individuals to notify',
          });
        }
        else
        {
          let contactData = list[0].email_list;
          contactData.forEach(doc => {
            console.log(doc.email);
            sendUserEmail(doc.email,notificationData.subject,notificationData.message);
        });

        }
            
          return res.status(200).send({
            message: 'Successfully Notified Individuals',
            data: list
          });
      
      } catch (error) {
          console.log(error);
          return res.status(500).send({
            message: error.message || "Some error occurred while notifying individuals."
          });
      }
    });


    //////////////////
    /**
 * @swagger
 * /health/setlist:
 *   post:
 *     description: sets list of health facilities of a province
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
     healthApp.post('/api/health/setlist', async (req, res) => {
      try {
        let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.province == null || reqJson.province === '') {
            fieldErrors.push({field: 'province ', message: 'province may not be empty'});
          }
          if (reqJson.vaccine_sites == null || reqJson.vaccine_sites === '') {
            fieldErrors.push({field: 'vaccine_sites ', message: 'vaccine_sites may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }

          let provinceData = {
            province:reqJson.province,
            vaccine_sites:reqJson.vaccine_sites
          }
          await database.collection('vaccine-sites').doc(reqJson.province).set(provinceData); 
        return res.status(200).send({
          message: 'Successfully stored list',
          data: provinceData
        });
      }
      catch (error) {
        console.log(error);
        return res.status(500).send({
          message: error.message || "Some error occurred"
        });
    }
  });

  

      //////////////////
    /**
 * @swagger
 * /health/setlist-testing-site:
 *   post:
 *     description: sets list of covid testing site facilities of a province
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
     healthApp.post('/api/health/testing-site', async (req, res) => {
      try {
        let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.province == null || reqJson.province === '') {
            fieldErrors.push({field: 'province ', message: 'province may not be empty'});
          }
          if (reqJson.testing_sites == null || reqJson.testing_sites === '') {
            fieldErrors.push({field: 'testing_sites ', message: 'testing_sites may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }

          let provinceData = {
            province:reqJson.province,
            testing_sites:reqJson.testing_sites
          }
          await database.collection('testing-sites').doc(reqJson.province).set(provinceData); 
        return res.status(200).send({
          message: 'Successfully stored list',
          data: provinceData
        });
      }
      catch (error) {
        console.log(error);
        return res.status(500).send({
          message: error.message || "Some error occurred"
        });
    }
  });
  
  /**
 * @swagger
 * /health/vaccine-sites/view:
 *   post:
 *     description: retrieve all vaccine-sites in a province
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
healthApp.post('/api/health/vaccine-sites/view',async (req, res) => {
  try {
  let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.province == null || reqJson.province === '') {
            fieldErrors.push({field: 'province ', message: 'province may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }
      let document = database.collection('vaccine-sites').where("province", "==", reqJson.province);
      let snapshot = await document.get();
        
      let vaccine_sites = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            vaccine_sites.push(data);
        });
      
      return res.status(200).send({
        message: 'Successfully retrieved list',
        data: vaccine_sites
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching list."
      });
  }
});


/**
 * @swagger
 * /health/testing-sites/view:
 *   post:
 *     description: retrieve all testing-sites in a province
 *     requestBody:
 *       required: true
 *     responses: 
 *       200:
 *         description: Success 
 *  
 */
 healthApp.post('/api/health/testing-sites/view',async (req, res) => {
  try {
  let fieldErrors = [];
    
      if (req == null) {
        fieldErrors.push({field: null, message: 'Request object may not be null'});
      }
        let reqJson;
          try {
              reqJson = JSON.parse(req.body);
          } catch (e) {
              reqJson = req.body;
          }
          if (reqJson.province == null || reqJson.province === '') {
            fieldErrors.push({field: 'province ', message: 'province may not be empty'});
          }
        
          if (fieldErrors.length > 0) {
            console.log(fieldErrors);
            return res.status(400).send({
              message: '400 Bad Request: Incorrect fields',
              errors: fieldErrors
            });
          }
      let document = database.collection('testing-sites').where("province", "==", reqJson.province);
      let snapshot = await document.get();
        
      let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();

            list.push(data);
        });
      
      return res.status(200).send({
        message: 'Successfully retrieved list',
        data: list
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching list."
      });
  }
});
  
  
  exports.health = functions.https.onRequest(healthApp);