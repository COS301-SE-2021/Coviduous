const HealthCheck = require("../../models/health.check.model");
const Permission = require("../../models/permission.model");
const PermissionRequest = require("../../models/permission.request.model");
const notificationService = require("../../services/notification/notification.controller.js");
const uuid = require("uuid"); // npm install uuid
// For todays date;
Date.prototype.today = function () { 
  return ((this.getDate() < 10)?"0":"") + this.getDate() +"/"+(((this.getMonth()+1) < 10)?"0":"") + (this.getMonth()+1) +"/"+ this.getFullYear();
}

// For the time now
Date.prototype.timeNow = function () {
   return ((this.getHours() < 10)?"0":"") + this.getHours() +":"+ ((this.getMinutes() < 10)?"0":"") + this.getMinutes() +":"+ ((this.getSeconds() < 10)?"0":"") + this.getSeconds();
}

let database;
let notificationDatabase;
let reportingDatabase;

exports.setDatabase = async (db) => {
  database = db;
}

exports.setNotificationDatabase = async (db) => {
  notificationDatabase = db;
}

exports.setReportingDatabase = async (db) => {
  reportingDatabase = db;
}

exports.hasHighTemperature = async (temparature) => {
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

exports.getPredictionResult = async (d_t_prediction,dt_accuracy,naive_prediction,nb_accuracy)=>{
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
exports.permissionDeniedBadge = async (userId,userEmail) => {
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
  
      if (await database.createPermission(permissionId, permissionData) == true)
      {
        notificationService.sendUserEmail(userEmail,"ACCESS TO OFFICE DENIED","BASED ON YOUR HEALTH ASSESSMENT YOU HAVE BEEN DENIED OFFICE ACCESS PLEASE CONTACT YOUR ADMINISTRATOR FOR A REVIEW");
        console.log(permissionData);
        return true;
      }
      else
      {
        return false;
      }
}

exports.permissionAcceptedBadge = async (userId,userEmail) => {
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

  if (await database.createPermission(permissionId, permissionData) == true)
  {
    notificationService.sendUserEmail(userEmail,"ACCESS TO OFFICE GRANTED","BASED ON YOUR HEALTH ASSESSMENT YOU HAVE BEEN GRANTED OFFICE ACCESS.");
    console.log(permissionData);
    return true;
  }
  else
  {
    return false;
  }
}

///////////////// HEALTH CHECK /////////////////

exports.createHealthCheck = async (req, res) => {
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

    let healthCheckObj = new HealthCheck(healthCheckId, reqJson.userId, reqJson.name, reqJson.surname,
      reqJson.email, reqJson.phoneNumber, reqJson.temperature, reqJson.fever, reqJson.cough,
      reqJson.sore_throat, reqJson.chills, reqJson.aches, reqJson.nausea, reqJson.shortness_of_breath, 
      reqJson.loss_of_taste, reqJson.sixFeetContact, reqJson.testedPositive, reqJson.travelled);

    let healthCheckData = {
      healthCheckId: healthCheckObj.healthCheckId,
      userId: healthCheckObj.userId,
      name: healthCheckObj.name,
      surname: healthCheckObj.surname,
      email: healthCheckObj.email,
      phoneNumber: healthCheckObj.phoneNumber,
      temperature: healthCheckObj.temperature,
      fever: healthCheckObj.fever,
      cough: healthCheckObj.cough,
      soreThroat: healthCheckObj.soreThroat,
      chills: healthCheckObj.chills,
      aches: healthCheckObj.aches,
      nausea: healthCheckObj.nausea,
      shortnessOfBreath: healthCheckObj.shortnessOfBreath,
      lossOfTasteSmell: healthCheckObj.lossOfTasteSmell,
      sixFeetContact: healthCheckObj.sixFeetContact,
      testedPositive: healthCheckObj.testedPositive,
      travelled: healthCheckObj.travelled
    }
    //assess temparature first and if temparature is above covid19 threshold issue a permission not granted
    let highTemp= await this.hasHighTemperature(healthCheckObj.temperature);
    console.log(highTemp);
    // Prediction to external AI service is anonymous, we donot send out personal infromation to the external service
    // personal information eg. name,surname,phone numbers are not sent but only symptoms and and history of contact 
    //is used to make a prediction
     // if temparature is less than threshold evaluate the AI prediction and accuracy score
    let AIprediction=await this.getPredictionResult(reqJson.d_t_prediction,reqJson.dt_accuracy,reqJson.naive_prediction,reqJson.nb_accuracy);
    console.log(AIprediction);
    if(highTemp==true)
    {
      await this.permissionDeniedBadge(reqJson.userId,reqJson.email);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
      return res.status(200).send({
        message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
        data: healthCheckData
      });
    }
    else if(AIprediction==true)
    {
      //if prediction is positive issue out a permission denied
      await this.permissionDeniedBadge(reqJson.userId,reqJson.email);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
      ////////////////////////////////////////////////////////////////////////////////////////
      // update the health summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let healthSummaries = await reportingDatabase.viewHealthSummary();
    
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
        if(reqJson.userId==="VISITOR")
        {
          let numHealthChecksVisitors=filteredList[0].numHealthChecksVisitors;
          numHealthChecksVisitors++;

          await reportingDatabase.updateHealthSummaryVisitor(filteredList[0].healthSummaryId,numHealthChecksVisitors);
        }
        else
        {
          let numHealthChecksUsers=filteredList[0].numHealthChecksUsers;
          numHealthChecksUsers++;

          await reportingDatabase.updateHealthSummaryUser(filteredList[0].healthSummaryId,numHealthChecksUsers);

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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          
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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          

        }
    }
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
      await this.permissionAcceptedBadge(reqJson.userId,reqJson.email);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
          ////////////////////////////////////////////////////////////////////////////////////////
      // update the health check summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let healthSummaries = await reportingDatabase.viewHealthSummary();
    
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
        if(reqJson.userId==="VISITOR")
        {
          let numHealthChecksVisitors=filteredList[0].numHealthChecksVisitors;
          numHealthChecksVisitors++;

          await reportingDatabase.updateHealthSummaryVisitor(filteredList[0].healthSummaryId,numHealthChecksVisitors);
        }
        else
        {
          let numHealthChecksUsers=filteredList[0].numHealthChecksUsers;
          numHealthChecksUsers++;

          await reportingDatabase.updateHealthSummaryUser(filteredList[0].healthSummaryId,numHealthChecksUsers);

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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          
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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          

        }
    }
    //////////////////////////////////////////////////////////
      return res.status(200).send({
        message: 'Health Check Successfully Created , Access Granted',
        data: healthCheckData
      });

    }

    
  } catch (error) {
      console.log(error);
      return res.status(500).send(error);
  }
};


///////////////// PERMISSION /////////////////


exports.viewPermissions = async (req, res) => {
  try {
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let permissions = await database.viewPermissionsUserEmail(reqJson.userEmail);
      
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
};


///////////////// PERMISSION REQUEST /////////////////

exports.createPermissionRequest = async (req, res) => {
    try {
      let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let permissionRequestId = "PR-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();
  
      let permissionRequestObj = new PermissionRequest(permissionRequestId,reqJson.permissionId, reqJson.userId, reqJson.userEmail,reqJson.shiftNumber,
        timestamp, reqJson.reason, reqJson.adminId, reqJson.companyId)
  
      let permissionRequestData = {
        permissionRequestId: permissionRequestObj.permissionRequestId,
        permissionId:permissionRequestObj.permissionId,
        userId: permissionRequestObj.userId,
        userEmail:permissionRequestObj.userEmail,
        shiftNumber: permissionRequestObj.shiftNumber,
        timestamp: timestamp,
        reason: permissionRequestObj.reason,
        adminId: permissionRequestObj.adminId,
        companyId: permissionRequestObj.companyId,
      }
  
      if (await database.createPermissionRequest(permissionRequestData.permissionRequestId, permissionRequestData) == true)
      {
        let notificationId = "NTFN-" + uuid.v4();
        let timestamp = new Date().today() + " @ " + new Date().timeNow();
  
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
    
        await notificationDatabase.createNotification(notificationData.notificationId, notificationData);
        await notificationService.sendUserEmail(reqJson.adminEmail,notificationData.subject,notificationData.message);
        return res.status(200).send({
          message: 'Permission request successfully created',
          data: permissionRequestData
        });
      }
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
};
exports.viewPermissionsRequestsCompanyId = async (req, res) => {
  try {
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let permissionRequests = await database.viewPermissionRequestsCompanyId(reqJson.companyId);
      
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
};

exports.grantPermission = async (req, res) => {
  try {

    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
      let notificationId = "NTFN-" + uuid.v4();
      let timestamp = new Date().today() + " @ " + new Date().timeNow();

      let permissionRequests = await database.updatePermission(reqJson.permissionId);
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
  
      await notificationDatabase.createNotification(notificationData.notificationId, notificationData);
      await notificationService.sendUserEmail(notificationData.userEmail,notificationData.subject,notificationData.message);
      return res.status(200).send({
        message: 'Successfully updated the permission requests',
        data: permissionRequests
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching permission requests."
      });
  }
};

exports.reportInfection = async (req, res) => {
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

    await notificationDatabase.createNotification(notificationData.notificationId, notificationData);
    

    await database.reportInfection(notificationId,reportedInfectionData);
    await notificationService.sendUserEmail(reqJson.adminEmail,notificationData.subject,notificationData.message);

     ////////////////////////////////////////////////////////////////////////////////////////
      // update the health check summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let healthSummaries = await reportingDatabase.viewHealthSummary();
    
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

          await reportingDatabase.updateHealthSummaryReportedInfections(filteredList[0].healthSummaryId,numReportedInfections);

        

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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          

        
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
};



//////////////////////////////////////////////////////
exports.reportRecovery = async (req, res) => {
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

    await notificationDatabase.createNotification(notificationData.notificationId, notificationData);
    

    await database.reportRecovery(notificationId,reportedRecoveryData);
    await notificationService.sendUserEmail(reqJson.userEmail,notificationData.subject,notificationData.message);

     ////////////////////////////////////////////////////////////////////////////////////////
      // update the health check summary collection
      // first check if the current month and year you are currently in is registered

      let healthSummaryId = "HSID-" + uuid.v4();
      let month= timestamp.charAt(3)+timestamp.charAt(4);
      let year= timestamp.charAt(6)+timestamp.charAt(7)+timestamp.charAt(8)+timestamp.charAt(9);
      let healthSummaries = await reportingDatabase.viewHealthSummary();
    
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

          await reportingDatabase.updateHealthSummaryReportedRecoveries(filteredList[0].healthSummaryId,numReportedRecoveries);

        

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
            await reportingDatabase.setHealthSummary(healthSummaryId,healthSummary);
          

        
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
};







exports.deletePermissionRequest = async (req, res)=>{
try{
  let reqJson;
  try {
      reqJson = JSON.parse(req.body);
  } catch (e) {
      reqJson = req.body;
  }
  
    if ( await database.deletePermissionRequest(reqJson.permissionRequestId) == true)
      {
        return res.status(200).send({
        message: 'Successfully Deleted permissionRequest',
      });
    }
}catch(error){
  console.log(error);
  return res.status(500).send({

  });
}

};



//////////////////////////////////// Contact Tracing ///////////////////////////
///////////////
//returns a group of employees who fall under the same shift identified by the shiftId
exports.viewGroup = async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
      let group = await database.viewGroup(reqJson.shiftNumber);
      
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
};

//returns a shifts an employee was in based on the employee email
exports.viewShifts = async (req, res) => {
  try {
    let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
      let shifts = await database.viewShifts(reqJson.userEmail);
      
      return res.status(200).send({
        message: 'Successfully retrieved shifts',
        data: shifts
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while fetching shifts."
      });
  }
};

//uses the shiftid
exports.notifyGroup = async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }
    console.log(reqJson);
      let group = await database.viewGroup(reqJson.shiftNumber);
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
          notificationDatabase.createNotification(notificationData.notificationId, notificationData);
          notificationService.sendUserEmail(notificationData.userEmail,notificationData.subject,notificationData.message);
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
};

//upload documents
exports.uploadCovid19VaccineConfirmation = async (req, res) => {
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
        if ( await database.saveCovid19VaccineConfirmation(documentId,documentData) == true)
        {
      return res.status(200).send({
        message: 'Successfully stored vaccine confirmation document',
        data: documentData
      });
    }
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while storing vaccine document."
      });
  }
};

exports.uploadCovid19TestResults = async (req, res) => {
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
        if ( await database.saveCovid19TestResults(documentId,documentData) == true)
        {
      
      return res.status(200).send({
        message: 'Successfully stored test results',
        data: documentData
      });
    }
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: error.message || "Some error occurred while trying to store results."
      });
  }
};

// get documents 
exports.viewVaccineConfirmations = async (req, res) => {
  try {
      let reqJson;
      try {
          reqJson = JSON.parse(req.body);
      } catch (e) {
          reqJson = req.body;
      }

      let filteredList=[];
      let results = await database.getVaccineConfirmations();
      
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
  };

  exports.viewTestResults = async (req, res) => {
    try {
        let reqJson;
        try {
            reqJson = JSON.parse(req.body);
        } catch (e) {
            reqJson = req.body;
        }

        let filteredList=[];
        let results = await database.getTestResults();
        
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
    };