const HealthCheck = require("../../models/health.check.model");
const Permission = require("../../models/permission.model");
const PermissionRequest = require("../../models/permission.request.model");

let database;

exports.setDatabase = async (db) => {
  database = db;
}

///////////////// HEALTH CHECK /////////////////

exports.createHealthCheck = async (req, res) => {
  try {
    let randInt = Math.floor(1000 + Math.random() * 9000);
    let healthCheckId = "HTH-" + randInt.toString();

    let healthCheckObj = new HealthCheck(healthCheckId, req.body.userId, req.body.name, req.body.surname,
        req.body.email, req.body.phoneNumber, req.body.temperature, req.body.fever, req.body.cough,
        req.body.soreThroat, req.body.chills, req.body.aches, req.body.nausea, req.body.shortnessOfBreadth, 
        req.body.lossOfTasteSmell)

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
      shortnessOfBreath: healthCheckObj.shortnessOfBreadth,
      lossOfTasteSmell: healthCheckObj.lossOfTasteSmell
    }

    if (await database.createHealthCheck(healthCheckData.healthCheckId, healthCheckData) == true)
    {
      return res.status(200).send({
        message: 'Health check successfully created',
        data: healthCheckData
      });
    }
  } catch (error) {
      console.log(error);
      return res.status(500).send(error);
  }
};

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

///////////////// PERMISSION /////////////////

// exports.createPermission = async (req, res) => {
//     try {
//       let randInt = Math.floor(1000 + Math.random() * 9000);
//       let permissionId = "PRMN-" + randInt.toString();
//       let timestamp = new Date().toISOString();
  
//       let permissionObj = new Permission(permissionId, req.body.userId, timestamp, 
//         req.body.officeAccess, req.body.grantedBy)
  
//       let permissionData = {
//         permissionId: permissionObj.permissionId,
//         userId: permissionObj.userId,
//         timestamp: timestamp,
//         officeAccess: permissionObj.officeAccess,
//         grantedBy: permissionObj.grantedBy,
//       }
  
//       if (await database.createPermission(permissionData.healthCheckId, permissionData) == true)
//       {
//         return res.status(200).send({
//           message: 'Permission successfully created',
//           data: healthCheckData
//         });
//       }
//     } catch (error) {
//         console.log(error);
//         return res.status(500).send(error);
//     }
// };
  
// exports.viewPermissions = async (req, res) => {
//     try {
//         let permissions = await database.viewPermissions();
        
//         return res.status(200).send({
//         message: 'Successfully retrieved permissions',
//         data: permissions
//         });
//     } catch (error) {
//         console.log(error);
//         return res.status(500).send({
//         message: err.message || "Some error occurred while fetching permissions."
//         });
//     }
// };


///////////////// PERMISSION REQUEST /////////////////

// exports.createPermissionRequest = async (req, res) => {
//     try {
//       let randInt = Math.floor(1000 + Math.random() * 9000);
//       let permissionRequestId = "PRMN-" + randInt.toString();
//       let timestamp = new Date().toISOString();
  
//       let permissionRequestObj = new PermissionRequest(permissionRequestId, req.body.userId, req.body.shiftNumber,
//         timestamp, req.body.reason, req.body.adminId, req.body.companyId)
  
//       let permissionRequestData = {
//         permissionRequestId: permissionRequestObj.permissionRequestId,
//         userId: permissionRequestObj.userId,
//         shiftNumber: permissionRequestObj.shiftNumber,
//         timestamp: timestamp,
//         reason: permissionRequestObj.reason,
//         adminId: permissionRequestObj.adminId,
//         companyId: permissionRequestObj.companyId,
//       }
  
//       if (await database.createPermissionRequest(permissionRequestData.permissionRequestId, permissionRequestData) == true)
//       {
//         return res.status(200).send({
//           message: 'Permission request successfully created',
//           data: healthCheckData
//         });
//       }
//     } catch (error) {
//         console.log(error);
//         return res.status(500).send(error);
//     }
// };
  
// exports.viewPermissionRequests = async (req, res) => {
//     try {
//         let permissionRequests = await database.viewPermissionRequests();
        
//         return res.status(200).send({
//         message: 'Successfully retrieved permission requests',
//         data: permissionRequests
//         });
//     } catch (error) {
//         console.log(error);
//         return res.status(500).send({
//         message: err.message || "Some error occurred while fetching permission requests."
//         });
//     }
// };