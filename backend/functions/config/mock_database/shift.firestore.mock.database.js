var firebasemock = require('firebase-mock');
var triggers = require('../../tests/triggers.js');
var mockauth = new firebasemock.MockFirebase();
var mockfirestore = new firebasemock.MockFirestore();
var mocksdk = firebasemock.MockFirebaseSdk(null, function() {
    return mockauth;
  }, function() {
    return mockfirestore;
  });
var mockapp = mocksdk.initializeApp();
mockfirestore = new firebasemock.MockFirestore();
mockfirestore.autoFlush();
mockauth = new firebasemock.MockFirebase();
mockauth.autoFlush();

let databucket;

exports.getDataBucket = async () => {
    return databucket;
}


exports.createShift = async (shiftID, shiftdata) => {

    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            shiftID: shiftID,
            date: shiftdata.date,
            startTime: shiftdata.startTime,
             endTime: shiftdata.endTime,
        description: shiftdata.description,
         adminId: shiftdata.adminId,
          companyId: shiftdata.companyId,
           floorPlanNumber: shiftdata.floorPlanNumber,
        floorNumber: shiftdata.floorNumber, 
        roomNumber: shiftdata.roomNumber
            
        }, 'shift/' + shiftID),
        params: {
          uid: shiftID
        }
      };
      triggers.create(databucket);
      return true;
};



exports.createGroup = async (groupId, Groupdata) => {

    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            groupId: groupId, 
            groupName: Groupdata.groupName,
             userEmails: Groupdata.userEmails, 
           shiftNumber: Groupdata.shiftNumber, 
             adminId: Groupdata.adminId 
        }, 'group/' + groupId),
        params: {
          uid: groupId
        }
      };
      triggers.create(databucket);
      return true;
};



