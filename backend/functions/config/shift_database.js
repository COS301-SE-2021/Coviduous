exports.createShift = async (ShiftID,ShiftData) => { 
    let admin = require('firebase-admin');
    let db = admin.firestore();
    try {
        await db.collection('Shift').doc(ShiftID)
            .create(ShiftData); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};