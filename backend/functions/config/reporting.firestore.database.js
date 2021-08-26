let admin = require('firebase-admin');
let db = admin.firestore();

////////// HEALTH REPORTING ////////////
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

exports.addRecoveredEmployee = async (userId,recoveredData) =>{
    try{
        await db.collection('recovered-employees').doc(userId)
        .create(recoveredData);
        return true;
    } catch(error){
        console.log(error);
        return false;
    }
};

exports.viewRecoveredEmployee = async () =>{
    try{
        const document = db.collection('recovered-employees');
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

exports.viewSickEmployees = async (companyId) => {
    try {
        const document = db.collection('sick-employees').where("companyId", "==", companyId);
        const snapshot = await document.get();

        let list = [];

        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });

        return list;
    } catch (error) {
        console.log(error);
        return error;
    }
};

////////// COMPANY REPORTING ////////////

/////// company-data ////////
exports.addCompanyData = async (companyId, data) => {
    try {
        await db.collection('company-data').doc(companyId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// returns data for 1 document 
exports.getCompanyData = async (companyId) => {
    try {
        let response = db.collection('company-data').doc(companyId);
        let doc = await response.get();
        let res = doc.data()
        
        return res;
    } catch (error) {
        console.log(error);
        return false;
    }
};

// returns list data for multiple documents where companyId = given companyId value
// exports.viewCompanyData = async (companyId) => {
//     try {
//         const document = db.collection('company-data').where("companyId", "==", companyId);
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

exports.updateNumberOfRegisteredUsers = async (companyId, value) => {
    try {
        const document = db.collection('company-data').doc(companyId);

        await document.update({
            numberOfRegisteredUsers: value
        });
        return true;
    }
    catch (error) {
        console.log(error);
        return false;
    }
};

exports.updateNumberOfRegisteredAdmins = async (companyId, value) => {
    try {
        const document = db.collection('company-data').doc(companyId);

        await document.update({
            numberOfRegisteredAdmins: value
        });
        return true;
    }
    catch (error) {
        console.log(error);
        return false;
    }
};

exports.addNumberOfRegisteredUsersCompanyData = async (companyId, currentNumRegisteredUsersInCompanyData) => {
    try {
        if (parseInt(currentNumRegisteredUsersInCompanyData) >= 0)
        {
            let newNumRegisteredUsers = parseInt(currentNumRegisteredUsersInCompanyData) + 1;
            newNumRegisteredUsers = newNumRegisteredUsers.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRegisteredUsers": newNumRegisteredUsers
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.decreaseNumberOfRegisteredUsersCompanyData = async (companyId, currentNumRegisteredUsersInCompanyData) => {
    try {
        if (parseInt(currentNumRegisteredUsersInCompanyData) > 0)
        {
            let newNumRegisteredUsers = parseInt(currentNumRegisteredUsersInCompanyData) - 1;
            newNumRegisteredUsers = newNumRegisteredUsers.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRegisteredUsers": newNumRegisteredUsers
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.addNumberOfRegisteredAdminsCompanyData = async (companyId, currentNumRegisteredAdminsInCompanyData) => {
    try {
        if (parseInt(currentNumRegisteredAdminsInCompanyData) >= 0)
        {
            let newNumRegisteredAdmins = parseInt(currentNumRegisteredAdminsInCompanyData) + 1;
            newNumRegisteredAdmins = newNumRegisteredAdmins.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRegisteredAdmins": newNumRegisteredAdmins
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.decreaseNumberOfRegisteredAdminsCompanyData = async (companyId, currentNumRegisteredAdminsInCompanyData) => {
    try {
        if (parseInt(currentNumRegisteredAdminsInCompanyData) > 0)
        {
            let newNumRegisteredAdmins = parseInt(currentNumRegisteredAdminsInCompanyData) - 1;
            newNumRegisteredAdmins = newNumRegisteredAdmins.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRegisteredAdmins": newNumRegisteredAdmins
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.addNumberOfFloorplansCompanyData = async (companyId, currentNumFloorplansInCompanyData) => {
    try {
        if (parseInt(currentNumFloorplansInCompanyData) >= 0)
        {
            let newNumFloorplans = parseInt(currentNumFloorplansInCompanyData) + 1;
            newNumFloorplans = newNumFloorplans.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfFloorplans": newNumFloorplans
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.decreaseNumberOfFloorplansCompanyData = async (companyId, currentNumFloorplansInCompanyData) => {
    try {
        if (parseInt(currentNumFloorplansInCompanyData) > 0)
        {
            let newNumFloorplans = parseInt(currentNumFloorplansInCompanyData) - 1;
            newNumFloorplans = newNumFloorplans.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfFloorplans": newNumFloorplans
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.addNumberOfFloorsCompanyData = async (companyId, currentNumFloorsInCompanyData) => {
    try {
        if (parseInt(currentNumFloorsInCompanyData) >= 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) + 1;
            newNumFloors = newNumFloors.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfFloors": newNumFloors
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.decreaseNumberOfFloorsCompanyData = async (companyId, currentNumFloorsInCompanyData) => {
    try {
        if (parseInt(currentNumFloorsInCompanyData) > 0)
        {
            let newNumFloors = parseInt(currentNumFloorsInCompanyData) - 1;
            newNumFloors = newNumFloors.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfFloors": newNumFloors
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.addNumberOfRoomsCompanyData = async (companyId, currentNumRoomsInCompanyData) => {
    try {
        if (parseInt(currentNumRoomsInCompanyData) >= 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) + 1;
            newNumRooms = newNumRooms.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRooms": newNumRooms
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.decreaseNumberOfRoomsCompanyData = async (companyId, currentNumRoomsInCompanyData) => {
    try {
        if (parseInt(currentNumRoomsInCompanyData) > 0)
        {
            let newNumRooms = parseInt(currentNumRoomsInCompanyData) - 1;
            newNumRooms = newNumRooms.toString();

            response = await db.collection('company-data').doc(companyId).update({
                "numberOfRooms": newNumRooms
            });
        
            return true;
        }
    } catch (error) {
        console.log(error);
        return false;
    }
};


/////// users-data ////////
exports.generateUsersData = async (usersDataId, data) => {
    try {
        await db.collection('users-data').doc(usersDataId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};

exports.viewUsersData = async () => {
    try {
        const document = db.collection('users-data');
        const snapshot = await document.get();
        
        let list = [];
        
        snapshot.forEach(doc => {
            let data = doc.data();
            list.push(data);
        });
    
        let usersData = list;
        
        return usersData;
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.updateTotalRegisteredUsers = async (usersDataId, value) => {
    try {
        const document = db.collection('users-data').doc(usersDataId); //or db.collection().where()

        await document.update({
            totalRegisteredUsers: value
        });
        return true;
    }
    catch (error) {
        console.log(error);
        return false;
    }
};

exports.getTotalUsers = async () => {
    try {
        const document = db.collection('users');
        const snapshot = await document.get();
        
        let counter = 0;
        
        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(counter);
            counter++;
        });
        
        //console.log(counter)
        return counter
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.getTotalAdmins = async () => {
    try {
        const document = db.collection('users').where("type","==", "Admin"); // or "ADMIN"
        const snapshot = await document.get();
        
        let counter = 0;
        
        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(counter);
            counter++;
        });
        
        //console.log(counter)
        return counter
    } catch (error) {
        console.log(error);
        return error;
    }
};

exports.getTotalEmployees = async () => {
    try {
        const document = db.collection('users').where("type","==", "User"); // or "USER"
        const snapshot = await document.get();
        
        let counter = 0;
        
        snapshot.forEach(doc => {
            let data = doc.data();
            //console.log(counter);
            counter++;
        });
        
        //console.log(counter)
        return counter
    } catch (error) {
        console.log(error);
        return error;
    }
};

//health summary

exports.viewHealthSummary = async () => {
    try {
      const document = db.collection('health-summary');
      const snapshot = await document.get();
      
      let list = [];
      
      snapshot.forEach(doc => {
          let data = doc.data();
          list.push(data);
      });
  
      lastQuerySucceeded=true;
      return list;
    } catch (error) {
      console.log(error);
      lastQuerySucceeded=false;
    }
  };

  exports.setHealthSummary = async (healthSummaryId,data) => {
    try {
        await db.collection('health-summary').doc(healthSummaryId)
          .create(data);
        return true;
    } catch (error) {
        console.log(error);
        return false;
    }
};