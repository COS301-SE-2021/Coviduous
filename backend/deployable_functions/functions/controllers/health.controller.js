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

healthApp.post('/api/health/health-check', async (req, res) => {
  res.set({
    'Connection': 'Keep-Alive',
    'Keep-Alive': 'timeout=30, max=3000'
  });
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


  exports.health = functions.https.onRequest(healthApp);