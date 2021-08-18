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


exports.createBooking = async (bookingNumber, bookingdata) => {

    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            bookingNumber: bookingNumber, 
            deskNumber: bookingdata.deskNumber,
            floorPlanNumber: bookingdata.floorPlanNumber,
            floorNumber: bookingdata.floorNumber,
            roomNumber: bookingdata.roomNumber, 
            timestamp: bookingdata.timestamp, 
            userId: bookingdata.userId, 
            companyId: bookingdata.companyId
        }, 'office/' + bookingNumber),
        params: {
          uid: bookingNumber
        }
      };
      triggers.create(databucket);
      return true;
};
exports.deleteBooking = async (bookingNumber) => {
    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            bookingNumber: bookingNumber, 
            deskNumber: "",
            floorPlanNumber: "",
            floorNumber: "",
            roomNumber: "", 
            timestamp: "", 
            userId: "", 
            companyId: ""
          
        }, 'office/' + bookingNumber),
        params: {
          uid: bookingNumber
        }
      };
      triggers.remove(bookingNumber);
      return true;
};
