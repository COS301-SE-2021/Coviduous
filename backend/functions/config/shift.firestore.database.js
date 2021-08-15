let admin = require('firebase-admin');
let db = admin.firestore();

exports.createShift = async (ShiftID,ShiftData) => { 
    try {
        await db.collection('shift').doc(ShiftID)
            .create(ShiftData); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};
exports.createGroup = async (groupId, groupData) =>{
    try{
        await db.collection('group').doc(groupId)
        .create(groupData);
        return true;
    }
    catch(error){
        console.log(error);
        return false;
    }
}
exports.getGroup = async () =>{
    try{
        const document = db.collection('group');
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
}
exports.viewShifts = async () => {
    try {
        const document = db.collection('shift');
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
        const document = db.collection('shift').doc(ShiftID); 
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
  }
exports.updateShift = async (shiftID,shiftData) =>{
  try{

       const document = db.collection('shift').doc(shiftID);
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
