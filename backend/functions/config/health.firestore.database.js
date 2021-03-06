const admin = require('firebase-admin'); 
//used to fetch shifts for contact tracing using employeeId
let shiftDb = require("../config/shift.firestore.database.js");

const db = admin.firestore();

// generate random healthCheckId number and pass in doc('') before creation

///////////////// HEALTH CHECK /////////////////

exports.createHealthCheck = async (healthCheckId, data) => {
    try {
        await db.collection('health-check').doc(healthCheckId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.reportInfection = async (infectionId, data) => {
    try {
        await db.collection('reported-infections').doc(infectionId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.reportRecovery = async (recoveryId, data) => {
    try {
        await db.collection('reported-recoveries').doc(recoveryId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.viewHealthChecks = async () => {
    try {
        const document = db.collection('health-check');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let healthChecks = list;
        
        return healthChecks;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewHealthCheckUserId = async (value) => {
    try {
        const document = db.collection('health-check').where("userId", "==", value);
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let healthChecks = list;
        
        return healthChecks;
    } catch (error) {
        console.log(error);
        return error;
    }
};

///////////////// PERMISSIONS /////////////////

exports.createPermission = async (permissionId, data) => {
    try {
        await db.collection('permissions').doc(permissionId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.viewPermissions = async () => {
    try {
        const document = db.collection('permissions');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissions = list;
        
        return permissions;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewPermissionsUserEmail = async (value) => {
    try {
        const document = db.collection('permissions').where("userEmail", "==", value);
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissions = list;
        
        return permissions;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewPermissionsUserId = async (value) => {
    try {
        const document = db.collection('permissions').where("userId", "==", value);
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissions = list;
        
        return permissions;
    } catch (error) {
        console.log(error);
        return error;
    }
};

///////////////// PERMISSION REQUEST /////////////////

exports.createPermissionRequest = async (permissionRequestId, data) => {
    try {
        await db.collection('permission-requests').doc(permissionRequestId)
          .create(data); // .add - auto generates document id
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};
exports.updatePermission = async (permissionId) =>{
    try {
      response= await db.collection('permissions').doc(permissionId).update(
      {
          grantedBy:"ADMIN",
          officeAccess:true
      }
      );
      
      return true;
    } catch (error) {
      console.log(error);
      return false;
    }
  };

exports.deletePermissionRequest = async (permissionRequestId) => {
    try {
        const document = db.collection('permission-requests').doc(permissionRequestId);
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};


exports.viewPermissionRequests = async () => {
    try {
        const document = db.collection('permission-requests');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissionRequests = list;
        
        return permissionRequests;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewPermissionRequestsCompanyId = async (value) => {
    try {
        const document = db.collection('permission-requests').where("companyId", "==", value);
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let permissions = list;
        
        return permissions;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewGroup = async (shiftNumber) => {
    try {
        const document = db.collection('groups');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            if(obj.shiftNumber===shiftNumber)
            {
                group.push(obj);
            }
            else
            {
            }
          });
        
        return group;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.viewShifts = async (userEmail) => {
    try {
        const document = db.collection('groups');
        const snapshot = await document.get();
        
        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            console.log(data);
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            for (var i = 0; i < obj.userEmails.length; i++) {
                if (obj.userEmails[i] === userEmail) {
                    group.push(obj);
                }
            }
        });

        let shifts = await shiftDb.viewShifts();
        let userShifts=[];
        group.forEach(obj => {
            shifts.forEach(obj2 => {
            if(obj2.shiftID===obj.shiftNumber) {
                userShifts.push(obj2);
            }});
        });

        return userShifts;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.saveCovid19VaccineConfirmation = async (documentId, data) => {
    try {
        await db.collection('vaccine-confirmations').doc(documentId)
          .create(data); 
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.saveCovid19TestResults = async (documentId, data) => {
    try {
        await db.collection('test-results').doc(documentId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.getVaccineConfirmations = async () => {
    try {
      const document = db.collection('vaccine-confirmations');
      const snapshot = await document.get();
      
      let list = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          list.push(data);
      });
  
      lastQuerySucceeded=true;
      return list;
    } catch (error) {
      console.log(error);
      lastQuerySucceeded=false;
    }
  };

  exports.getTestResults = async () => {
    try {
      const document = db.collection('test-results');
      const snapshot = await document.get();
      
      let list = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          list.push(data);
      });
  
      lastQuerySucceeded=true;
      return list;
    } catch (error) {
      console.log(error);
      lastQuerySucceeded=false;
    }
  };