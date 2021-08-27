let admin = require('firebase-admin');
let db = admin.firestore();

exports.createShift = async (data,ShiftData) => { 
    try {
        let c="";
        await db.collection('shifts').doc(ShiftData.ShiftID)
            .create(ShiftData); 
            const document =  db.collection('summary-shifts').where("month","==",data.month);
            let snapshot = await document.get(); 
    
           let list = [];
    
            snapshot.forEach(doc => {
                let d = doc.data();
                list.push(d);
            });
            
            for (const element of list) {
                if(data.month===element.month){
                    c="checked";  
                }
            }
            if(c==="")
            {
                await db.collection('summary-shifts').doc(data.summaryShiftId)
                .create(data); 
            }
            if(c==="checked")
            {
                const documents =  db.collection('summary-shifts').where("month","==",data.month);
                let s = await documents.get(); 
        
               let lists = [];
        
                s.forEach(doc => {
                    let ds = doc.data();
                    lists.push(ds);
                });
                
                let summaryId;
                let count;
                for (const elements of lists) {
                    
                    summaryId = elements.summaryShiftId;
                    count =elements.numShifts;
    
                }
    
                let numShifts = parseInt(count) + 1;
                numShifts = numShifts.toString();
            
                
                const documented = db.collection('summary-shifts').doc(summaryId);
                await documented.update({ 
                    numShifts:numShifts
                 });
    
        }    
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
