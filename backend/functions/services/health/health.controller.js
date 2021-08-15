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

exports.setDatabase = async (db) => {
  database = db;
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

exports.getPredictionResult = async ()=>{
  //if pognosis is positive we return true else return false
  return false;


}
exports.permissionDeniedBadge = async (userId) => {
      let permissionId = "PRMN-" + uuid.v4();
      let timestamp =new Date().today() + " @ " + new Date().timeNow();
      let acessPermission=false;
      let authorizedBy="SYSTEM";

      let permissionData = {
        permissionId: permissionId,
        userId:userId,
        timestamp: timestamp,
        officeAccess: acessPermission,
        grantedBy:authorizedBy
      }
  
      if (await database.createPermission(permissionId, permissionData) == true)
      {
        return true;
      }
      else
      {
        return false;
      }
}

exports.permissionAcceptedBadge = async (userId) => {
  let permissionId = "PRMN-" + uuid.v4();
  let timestamp =new Date().today() + " @ " + new Date().timeNow();
  let acessPermission=true;
  let authorizedBy="SYSTEM";

  let permissionData = {
    permissionId: permissionId,
    userId:userId,
    timestamp: timestamp,
    officeAccess: acessPermission,
    grantedBy:authorizedBy
  }

  if (await database.createPermission(permissionId, permissionData) == true)
  {
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
    let healthCheckId = "HTH-" + uuid.v4();
    //add a time attribute

    let healthCheckObj = new HealthCheck(healthCheckId, req.body.userId, req.body.name, req.body.surname,
        req.body.email, req.body.phoneNumber, req.body.temperature, req.body.fever, req.body.cough,
        req.body.soreThroat, req.body.chills, req.body.aches, req.body.nausea, req.body.shortnessOfBreath, 
        req.body.lossOfTasteSmell, req.body.sixFeetContact, req.body.testedPositive, req.body.travelled);

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
    // Prediction to external AI service is anonymous, we donot send out personal infromation to the external service
    // personal information eg. name,surname,phone numbers are not sent but only symptoms and and history of contact 
    //is used to make a prediction
     // if temparature is less than threshold evaluate the AI prediction and accuracy score
    let AIprediction=await this.getPredictionResult();
    if(highTemp)
    {
      await this.permissionDeniedBadge(req.body.userId);
      await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData);
      return res.status(200).send({
        message: 'Health Check Successfully Created , But Access Denied Please Consult A Medical Professional You May Be At Risk Of COVID-19',
        data: healthCheckData
      });
    }
    else if(AIprediction)
    {
      //if prediction is positive issue out a permission denied
      await this.permissionDeniedBadge(req.body.userId);
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
      await this.permissionAcceptedBadge(req.body.userId);
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


/*admin can view health checks of users
exports.viewHealthChecks = async (req, res) => {
    try {
        let healthChecks = await database.viewHealthChecks();
        
        return res.status(200).send({
          message: 'Successfully retrieved health checks',
          data: healthChecks
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
          message: err.message || "Some error occurred while fetching health checks."
        });
    }
};


exports.viewHealthCheckUserId = async (req, res) => {
    try {
        let healthChecks = await database.viewHealthCheckUserId(req.body.userId);
        
        return res.status(200).send({
          message: 'Successfully retrieved health checks',
          data: healthChecks
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
          message: err.message || "Some error occurred while fetching health checks."
        });
    }
};

///////////////// PERMISSION /////////////////

/*
exports.createPermission = async (req, res) => {
    try {
      let permissionId = "PRMN-" + uuid.v4();
      let timestamp = new Date().toISOString();
  
      let permissionObj = new Permission(permissionId, req.body.userId, timestamp, 
        req.body.officeAccess, req.body.grantedBy)
  
      let permissionData = {
        permissionId: permissionObj.permissionId,
        userId: permissionObj.userId,
        timestamp: timestamp,
        officeAccess: permissionObj.officeAccess,
        grantedBy: permissionObj.grantedBy,
      }
  
      if (await database.createPermission(permissionData.permissionId, permissionData) == true)
      {
        return res.status(200).send({
          message: 'Permission successfully created',
          data: permissionData
        });
      }
    } catch (error) {
        console.log(error);
        return res.status(500).send(error);
    }
};
  
exports.viewPermissions = async (req, res) => {
    try {
        let permissions = await database.viewPermissions();
        
        return res.status(200).send({
        message: 'Successfully retrieved permissions',
        data: permissions
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
        message: err.message || "Some error occurred while fetching permissions."
        });
    }
};
*/
exports.viewPermissions = async (req, res) => {
  try {
      let permissions = await database.viewPermissionsUserEmail(req.body.userEmail);
      
      return res.status(200).send({
        message: 'Successfully retrieved permissions',
        data: permissions
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching permissions."
      });
  }
};


///////////////// PERMISSION REQUEST /////////////////

exports.createPermissionRequest = async (req, res) => {
    try {
      let permissionRequestId = "PR-" + uuid.v4();
      let timestamp = new Date().toISOString();
  
      let permissionRequestObj = new PermissionRequest(permissionRequestId, req.body.userId, req.body.shiftNumber,
        timestamp, req.body.reason, req.body.adminId, req.body.companyId)
  
      let permissionRequestData = {
        permissionRequestId: permissionRequestObj.permissionRequestId,
        userId: permissionRequestObj.userId,
        shiftNumber: permissionRequestObj.shiftNumber,
        timestamp: timestamp,
        reason: permissionRequestObj.reason,
        adminId: permissionRequestObj.adminId,
        companyId: permissionRequestObj.companyId,
      }
  
      if (await database.createPermissionRequest(permissionRequestData.permissionRequestId, permissionRequestData) == true)
      {
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
  
/*
exports.viewPermissionRequests = async (req, res) => {
    try {
        let permissionRequests = await database.viewPermissionRequests();
        
        return res.status(200).send({
        message: 'Successfully retrieved permission requests',
        data: permissionRequests
        });
    } catch (error) {
        console.log(error);
        return res.status(500).send({
        message: err.message || "Some error occurred while fetching permission requests."
        });
    }
};
*/
exports.viewPermissionsRequestsCompanyId = async (req, res) => {
  try {
      let permissionRequests = await database.viewPermissionRequestsCompanyId(req.body.companyId);
      
      return res.status(200).send({
        message: 'Successfully retrieved permission requests',
        data: permissionRequests
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching permission requests."
      });
  }
};
exports.deletePermissionsPermissionId = async (req, res)=>{
try{
  
    if ( await database.deletePermissionsPermissionId(req.body.permissionId) == true)
      {
        return res.status(200).send({
        message: 'Successfully Deleted permission',
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
      let group = await database.viewGroup(req.body.shiftNumber);
      
      return res.status(200).send({
        message: 'Successfully retrieved group',
        data: group
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching group."
      });
  }
};

//returns a shifts an employee was in based on the employee email
exports.viewShifts = async (req, res) => {
  try {
      let shifts = await database.viewShifts(req.body.userEmail);
      
      return res.status(200).send({
        message: 'Successfully retrieved shifts',
        data: shifts
      });
  } catch (error) {
      console.log(error);
      return res.status(500).send({
        message: err.message || "Some error occurred while fetching shifts."
      });
  }
};
