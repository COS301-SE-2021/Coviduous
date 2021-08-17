//const admin = require('firebase-admin');
//const db = admin.firestore();
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

exports.createNotification = async (notificationId, testdata) => {

    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
          notificationId: notificationId,
          userId: testdata.userId,
          userEmail: testdata.userEmail,
          subject: testdata.subject,
          message: testdata.message,
          timestamp: testdata.timestamp,
          adminId: testdata.adminId,
          companyId: testdata.companyId
        }, 'notifications/' + notificationId),
        params: {
          uid: notificationId
        }
      };
      triggers.create(databucket);
      return true;

};

exports.deleteNotification = async (notificationId) => {
    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
          notificationId: notificationId,
          userId: "Mock object to delete",
          userEmail: "Mock object to delete",
          subject: "Mock object to delete",
          message: "Mock object to delete",
          timestamp: "Mock object to delete",
          adminId: "Mock object to delete",
          companyId: "Mock object to delete"
        }, 'notifications/' + notificationId),
        params: {
          uid: notificationId
        }
      };
      triggers.remove(databucket);
      return true;
};



exports.viewNotificationsUserEmail = async (userEmail) => {
    let dummyNotifications=[];
    let dummyNotif1={
        notificationId: "Mock object",
        userId: "Mock object",
        subject: "Mock object",
        message: "Mock object",
        timestamp: "Mock object",
        adminId: "Mock object ",
        companyId: "Mock object",
        userEmail:userEmail
    }
    let dummyNotif2={
        notificationId: "Mock object",
        userId: "Mock object",
        subject: "Mock object",
        message: "Mock object",
        timestamp: "Mock object",
        adminId: "Mock object ",
        companyId: "Mock object",
        userEmail:userEmail
    }
    let dummyNotif3={
        notificationId: "Mock object",
        userId: "Mock object",
        subject: "Mock object",
        message: "Mock object",
        timestamp: "Mock object",
        adminId: "Mock object ",
        companyId: "Mock object",
        userEmail:userEmail
    }
    dummyNotifications.push(dummyNotif1);
    dummyNotifications.push(dummyNotif2);
    dummyNotifications.push(dummyNotif3);
    databucket = {
        data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
          notificationId: "Mock object",
          userId: "Mock object",
          userEmail: userEmail,
          subject: "Mock object",
          message: "Mock object",
          timestamp: "Mock object",
          adminId: "Mock object ",
          companyId: "Mock object"
        }, 'notifications/' + "mock object"),
        params: {
          uid: "mock object"
        }
      };
      triggers.read(databucket);
      return dummyNotifications;
};
