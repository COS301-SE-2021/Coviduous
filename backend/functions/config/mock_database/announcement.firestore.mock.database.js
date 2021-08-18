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


exports.createAnnouncement = async (announcementId, testdata) => {

    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            announcementId: announcementId,
            type: testdata.type,
            message: testdata.message,
            timestamp: testdata.timestamp,
            adminId: testdata.adminId,
            companyId: testdata.companyId
        }, 'announcements/' + announcementId),
        params: {
          uid: announcementId
        }
      };

      triggers.create(databucket);
      return true;
};
exports.deleteAnnouncement = async (announcementId) => {
    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            announcementId: announcementId,
            type: "",
            message: "",
            timestamp: "",
            adminId: "",
            companyId: "" 
          
        }, 'announcements/' + announcementId),
        params: {
          uid: announcementId
        }
      };
      triggers.remove(databucket);
      return true;
};
exports.viewAnnouncements = async () => {
    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
            announcementId: announcementId,
            type: "General",
            message: "Alert",
            timestamp: "12 Aug ",
            adminId: "ADM-110",
            companyId: "CID-120" 
          
        }, 'announcements/' + "mock object"),
        params: {
          uid: "mock object"
        }
      };
      triggers.read(databucket);
      return true;
};