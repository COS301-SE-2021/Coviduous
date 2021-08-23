let admin = require('firebase-admin');
let db = admin.firestore();

// functions
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

// need to test
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

// exports.viewSickEmployees = async (companyId) => {
//     try {
//         const document = db.collection('sick-employees').where("companyId", "==", companyId);
//         const snapshot = await document.get();

//         let list = [];

//         snapshot.forEach(doc => {
//             let data = doc.data();
//             list.push(data);
//         });

//         return list;
//     } catch (error) {
//         console.log(error);
//         return error;
//     }
// };
