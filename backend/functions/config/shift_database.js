exports.createShift = async (ShiftID) => { 
    let admin = require('firebase-admin');
    let db = admin.firestore();
    try {
        await db.collection('Shift').doc(ShiftID)
            .create(ShiftID); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};