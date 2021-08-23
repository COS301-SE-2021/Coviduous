let admin = require('firebase-admin');
let db = admin.firestore();

// functions
// exports.addSickEmployee = async (sickEmployeeId, data) => {
//     try {
//         await db.collection('sick-employees').doc(sickEmployeeId)
//           .create(data); // .add - auto generates document id
//         return true;
//     } catch (error) {
//         console.log(error);
//         return false;
//     }
// };

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