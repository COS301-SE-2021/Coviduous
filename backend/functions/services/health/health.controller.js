const HealthCheck = require("../../models/health.check.model");
const Permission = require("../../models/permission.model");
const PermissionRequest = require("../../models/permission.request.model");
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

exports.setDatabase = async (db) => {
  database = db;
}

exports.setNotificationDatabase = async (db) => {
  notificationDatabase = db;
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
  try {
    let reqJson;
    try {
        reqJson = JSON.parse(req.body);
    } catch (e) {
        reqJson = req.body;
    }
    let healthCheckId = "HTH-" + uuid.v4();
    //add a time attribute

    let healthCheckObj = new HealthCheck(healthCheckId, reqJson.userId, reqJson.name, reqJson.surname,
      reqJson.userEmail, reqJson.phoneNumber, reqJson.temperature, reqJson.fever, reqJson.cough,
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
      await this.permissionDeniedBadge(reqJson.userId,reqJson.userEmail);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
      return res.status(200).send({
        message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
        data: healthCheckData
      });
    }
    else if(AIprediction==true)
    {
      //if prediction is positive issue out a permission denied
      await this.permissionDeniedBadge(reqJson.userId,reqJson.userEmail);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
      return res.status(200).send({
        message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
        data: healthCheckData
      });

    }
    else
    {
      //if prediction is negative and temparature is low we can offer a permissions granted badge
      // all healthchecks are saved into the database for reporting
      await this.permissionAcceptedBadge(reqJson.userId,reqJson.userEmail);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
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
        let notificationId = "NTFN-" + uuid.v4();
        let timestamp = new Date().today() + " @ " + new Date().timeNow();
  
        let notificationData = {
          notificationId: notificationId,
          userId: "",
          userEmail:obj.userEmail,
          subject: "COVID-19 CONTACT RISK",
          message: "YOU MAY HAVE BEEN IN CLOSE CONTACT WITH SOMEONE WHO HAS COVID-19, PLEASE CONTACT THE HEALTH SERVICES AND YOUR ADMINISTRATOR",
          timestamp: timestamp,
          adminId: obj.adminId,
          companyId: ""
        }
        notificationDatabase.createNotification(notificationData.notificationId, notificationData);
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