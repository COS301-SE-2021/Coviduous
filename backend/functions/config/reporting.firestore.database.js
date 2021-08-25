let admin = require('firebase-admin');
let db = admin.firestore();

////////// HEALTH REPORTING ////////////
exports.addSickEmployee = async (sickEmployeeId, data) => {
    try {
        await db.collection('sick-employees').doc(sickEmployeeId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.addRecoveredEmployee = async (userId,recoveredData) =>{
    try{
        await db.collection('recovered-employees').doc(userId)
        .create(recoveredData);
        return true;
    } catch(error){
        console.log(error);
        return false;
    }
};

exports.viewRecoveredEmployee = async () =>{
    try{
        const document = db.collection('recovered-employees');
        const snapshot = await document.get();
    
        let list =[];
       snapshot.forEach(doc => {
          let data = doc.data();
            list.push(data);
        });
    return list;
    }catch(error){
        console.log(error);
        return false;
    }
};

// exports.viewSickEmployees = async () => {
//     try {
//         const document = db.collection('sick-employees');
//         const snapshot = await document.get();
        
//         let list = [];
        
//         snapshot.forEach(doc => {
//             let data = doc.data();
//             list.push(data);
//         });
    
//         let sickEmployees = list;
        
//         return sickEmployees;
//     } catch (error) {
//         console.log(error);
//         return error;
//     }
// };

exports.viewSickEmployees = async (companyId) => {
    try {
        const document = db.collection('sick-employees').where("companyId", "==", companyId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return error;
    }
};

////////// COMPANY REPORTING ////////////
exports.addCompanyData = async (companyId, data) => {
    try {
        await db.collection('company-data').doc(companyId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// exports.viewCompanyData = async () => {
//     try {
//         const document = db.collection('company-data');
//         const snapshot = await document.get();
        
//         let list = [];
        
//         snapshot.forEach(doc => {
//             let data = doc.data();
//             list.push(data);
//         });
    
//         let companyData = list;
        
//         return companyData;
//     } catch (error) {
//         console.log(error);
//         return error;
//     }
// };

exports.viewCompanyData = async (companyId) => {
    try {
        const document = db.collection('company-data').where("companyId", "==", companyId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.updateNumberOfRegisteredUsers = async (companyId, value) => {
    try {
        const document = db.collection('company-data').doc(companyId);

        await document.update({
            numberOfRegisteredUsers: value
        });
        return true;
    }
    catch (error) {
        console.log(error);
        return false;
    }
};