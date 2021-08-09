const admin = require('firebase-admin'); 

const db = admin.firestore();

// generate random healthCheckId number and pass in doc('') before creation

// create 'health-check', 'permissions', 'permission-requests' tables in firestore db

// exports.createHealthCheck = async (healthCheckId, data) => {
//     try {
//         await db.collection('health-check').doc(healthCheckId)
//           .create(data); // .add - auto generates document id
//         return true;
//     } catch (error) {
//         console.log(error);
//         return false;
//     }
// };