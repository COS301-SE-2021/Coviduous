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

  //var uid = '123';
  var announcementId = "ANNOUNC-" + uuid.v4();

  it('create announcement', function() {
    var event = {
      data: new firebasemock.DeltaDocumentSnapshot(mockapp, null, {
        announcementId: announcementId,
        type: 'general', 
        message: 'test message', 
        timestamp: 'test', 
        adminId: 'AID-test', 
        companyId: 'CID-test'
      }, 'announcements/' + announcementId),
      params: {
        uid: announcementId
      }
    };

    expect(event.data.get('type')).to.equal('general');
    expect(event.params.uid).to.equal(announcementId);

    triggers.create(event);
  });

  it('delete announcement', function() {
    var event = {
      data: new firebasemock.DeltaDocumentSnapshot(mockapp, {
        announcementId: announcementId,
        type: 'general', 
        message: 'test message', 
        timestamp: 'test', 
        adminId: 'AID-test', 
        companyId: 'CID-test'
      }, null, 'announcements/' + announcementId),
      params: {
        uid: announcementId
      }
    };

    expect(event.data.previous.get('type')).to.equal('general');
    expect(event.params.uid).to.equal(announcementId);

    triggers.remove(event);
  });

//   it('update', function() {
//     var event = {
//       data: new firebasemock.DeltaDocumentSnapshot(mockapp, {
//         name: 'bob',
//         createdTime: new Date()
//       }, {
//         name: 'bobby'
//       }, 'users/' + uid),
//       params: {
//         uid: uid
//       }
//     };

//     expect(event.data.previous.get('name')).to.equal('bob');
//     expect(event.data.get('name')).to.equal('bobby');
//     expect(event.params.uid).to.equal(uid);

//     triggers.update(event);
//   });
});

