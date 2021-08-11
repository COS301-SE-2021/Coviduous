const admin = require('firebase-admin'); 
//used to fetch shifts for contact tracing using employeeId
let shiftDb = require("../config/shift.firestore.database.js");

const db = admin.firestore();

// generate random healthCheckId number and pass in doc('') before creation

// create 'health-check', 'permissions', 'permission-requests' tables in firestore db

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
            list.push(data);
        });
        
        let group = [];
        list.forEach(obj => {
            if(obj.userEmail===userEmail)
            {
                group.push(obj);
            }
            else
            {
            }
          });

        let shifts = await shiftDb.viewShift();
        let userShifts=[];

        group.forEach(obj => {
            shifts.forEach(obj2 => {
            if(obj2.shiftID===obj.shiftNumber)
            {
                userShifts.push(obj2);
            }
            else
            {
            }
            
            });
          });
        
        return userShifts;
    } catch (error) {
        console.log(error);
        return error;
    }
};