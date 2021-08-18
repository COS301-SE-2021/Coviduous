let admin = require('firebase-admin');
let db = admin.firestore();

exports.createShift = async (ShiftID,ShiftData) => { 
    try {
        await db.collection('shifts').doc(ShiftID)
            .create(ShiftData); 
            return true;
      } catch (error) {
        console.log(error);
        return false;
      }
};

exports.createGroup = async (groupId, groupData) =>{
    try{
        await db.collection('groups').doc(groupId)
        .create(groupData);
        return true;
    }
    catch(error){
        console.log(error);
        return false;
    }
};

exports.getGroupForShift = async (shiftNumber) =>{
    try{
        const document = db.collection('groups').where("shiftNumber","==",shiftNumber);
        const snapshot = await document.get();
 
        let list =[];
 
         snapshot.forEach(doc => {
             let data = doc.data();
             list.push(data);
         });

         return list;
    }
    catch(error){
        console.log(error);
        return false;
    }
};

exports.getGroup = async () =>{
    try{
        const document = db.collection('groups');
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

exports.viewShifts = async () => {
    try {
        const document = db.collection('shifts');
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
        const document = db.collection('shifts').doc(ShiftID);
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.deleteGroup = async (groupId) => {
    try {
        const document = db.collection('groups').doc(groupId);
        await document.delete();
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.updateShift = async (shiftId,shiftData) => {
    try {
        const document = db.collection('shifts').doc(shiftId);
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
