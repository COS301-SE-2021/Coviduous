let admin = require('firebase-admin');
let db = admin.firestore();

exports.createShift = async (ShiftID,ShiftData) => { 
    try {
        await db.collection('Shift').doc(ShiftID)
            .create(ShiftData); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};

exports.deleteShift = async (ShiftID) => {
  try {
      const document = db.collection('Shift').doc(ShiftID); 
      await document.delete();
      return true;
  } catch (error) {
      console.log(error);
      return false;
  }
};
exports.viewShift = async () => {
  try {
      const document = db.collection('Shift');
      const snapshot = await document.get();

      let list = [];
      snapshot.forEach(doc => {
          let data = doc.data();
          list.push(data);
      });
  
      let shifts = list;
      return shifts;
  } catch (error) {
      console.log(error);
      return false;
  }
};


