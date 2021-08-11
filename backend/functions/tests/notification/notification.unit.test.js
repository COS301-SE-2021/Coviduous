var chai = require("chai");
var expect = chai.expect;
var uuid = require("uuid"); // npm install uuid
var triggers = require('../triggers.js');
var firebasemock = require('firebase-mock'); // npm install firebase-mock --save-dev
var mockauth = new firebasemock.MockFirebase();
var mockfirestore = new firebasemock.MockFirestore();

var mocksdk = firebasemock.MockFirebaseSdk(null, function() {
  return mockauth;
}, function() {
  return mockfirestore;
});

var mockapp = mocksdk.initializeApp();

describe('Firestore Function', function () {
  beforeEach(function() {
    mockfirestore = new firebasemock.MockFirestore();
    mockfirestore.autoFlush();
    mockauth = new firebasemock.MockFirebase();
    mockauth.autoFlush();
  });

  
  it('create notification', function() {
    var notificationId = "NTFN-" + uuid.v4();

    var event = {
      data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
        notificationId: notificationId,
        userId: 'UID-test',
        userEmail: 'test@gmail.com',
        subject: 'test subject',
        message: 'test message',
        timestamp: 'test',
        adminId: 'AID-test',
        companyId: 'CID-test'
      }, 'notifications/' + notificationId),
      params: {
        uid: notificationId
      }
    };

    expect(event.data.get('subject')).to.equal('test subject');
    expect(event.params.uid).to.equal(notificationId);

    triggers.create(event);
  });

  it('view notifications', function() {
    var notificationId = "NTFN-" + uuid.v4();
    var notificationId2 = "NTFN-" + uuid.v4();
    
    var event = {
      data: new firebasemock.DeltaDocumentSnapshot(mockapp, {
        notificationId: notificationId,
        userId: 'test',
        userEmail: 'test',
        subject: 'test',
        message: 'test',
        timestamp: 'test',
        adminId: 'test',
        companyId: 'test'
      }, 
      {
        notificationId: notificationId2,
        userId: 'test2',
        userEmail: 'test2',
        subject: 'test2',
        message: 'test2',
        timestamp: 'test2',
        adminId: 'test2',
        companyId: 'test2'
      }, 'notifications/' + notificationId),
      params: {
        uid: notificationId
      }
    };

    //expect(event.data.previous.get('subject')).to.equal('test');
    expect(event.data.get('subject')).to.equal('test2');
    expect(event.params.uid).to.equal(notificationId);

    triggers.read(event);
  });
});