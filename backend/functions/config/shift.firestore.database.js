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
exports.viewShifts = async () => {
    try {
        const document = db.collection('Shift');
        const snapshot = await document.get();
  
        let list = [];
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
  
        return list;
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
  }
exports.updateShift = async (shiftID,shiftData) =>{
  try{
       const document = db.collection('Shift').doc(shiftID);
       await document.update({
           startTime:shiftData.startTime,
           endTime:shiftData.endTime
       }); 
       return true;
       //return res.status(200).send();
  }
  catch (error) {
    console.log(error);
    return false;
    //return res.status(500).send(error);
}
};
