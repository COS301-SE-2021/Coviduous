var chai = require("chai");
var expect = chai.expect;
var uuid = require("uuid"); // npm install uuid
var triggers = require('../triggers.js');
var firebasemock = require('firebase-mock'); // npm install firebase-mock --save-dev
var mockauth = new firebasemock.MockFirebase();
var mockfirestore = new firebasemock.MockFirestore();
var announcementService= require("../../services/announcement/announcement.controller.js");

var mocksdk = firebasemock.MockFirebaseSdk(null, function() {
  return mockauth;
}, function() {
  return mockfirestore;
});

var mockapp = mocksdk.initializeApp();
//we have 3 main units create,delete and update for announcements

describe('Testing create announcement units', function () {
  //NOTE: you cannot check if credientials are vaild before checking if they were added to the request body or header first
  // This test is to check if the request contains the nessessery fields before we can check if they are vaild
  it('Test to identify if the the function can identify if the request has null fields, we will leave out the admin field from the request body',async function() {
    var reqBodyData = {
        announcementId: "mock",
        type: "mock", 
        message: "mock", 
        timestamp: "mock", 
        companyId: "mock"
      }
      var result= await announcementService.containsRequiredFieldsForCreateAnnouncement(reqBodyData);
    expect(result).to.be.false;
  });

  it('Test to identify if the the function can identify if the request has all fields but some have empty inputs, we will leave out the admin and message field from the request body',async function() {
    var reqBodyData = {
        announcementId: "mock",
        type: "mock", 
        message: "", 
        timestamp: "mock", 
        adminId:"",
        companyId: "mock"
      }
      var result= await announcementService.containsRequiredFieldsForCreateAnnouncement(reqBodyData);
    expect(result).to.be.false;
  });

  

  it('Throw exception if type is not set to GENERAL or EMERGENCY',async function() {
    var reqBodyData = {
        announcementId: "mock",
        type: "mock", 
        message: "mock", 
        timestamp: "mock", 
        adminId:"mock",
        companyId: "mock"
      }
      var result= await announcementService.containsRequiredFieldsForCreateAnnouncement(reqBodyData);
    expect(result).to.be.false;
  });

  it('Test to identify if the the function can identify if the request has the correct type, we will set the type to GENERAL',async function() {
    var reqBodyData = {
        announcementId: "mock",
        type: "GENERAL", 
        message: "mock", 
        timestamp: "mock", 
        adminId:"mock",
        companyId: "mock"
      }
      var result= await announcementService.containsRequiredFieldsForCreateAnnouncement(reqBodyData);
    expect(result).to.be.true;
  });

  it('Test to identify if the the function can identify if the request has the correct type, we will set the type to EMERGENCY',async function() {
    var reqBodyData = {
        announcementId: "mock",
        type: "EMERGENCY", 
        message: "mock", 
        timestamp: "mock", 
        adminId:"mock",
        companyId: "mock"
      }
      var result= await announcementService.containsRequiredFieldsForCreateAnnouncement(reqBodyData);
    expect(result).to.be.true;
  });

  it('Test to identify if the the function can identify if the request has the valid jwt token',async function() {
    //functionality for token needs to be added
    let token="";
      var result= await announcementService.verifyRequestToken(token);
    expect(result).to.be.true;
  });

  it('Test to identify if the the function can identify if the request has the invalid jwt token',async function() {
    //functionality for token needs to be added
    let token="";
      var result= await announcementService.verifyRequestToken(token);
    expect(result).to.be.true;
  });

  it('Test to identify if the the function can identify if the request has the valid user credientials',async function() {
    //functionality needs a user to be registered then we validate their credentials
    //validate their companyId and AdminId
    let adminId="";
    let companyId="";
      var result= await announcementService.verifyCredentials(adminId,companyId);
    expect(result).to.be.true;
  });

  it('Test to identify if the the function can identify if the request has the invalid user credientials',async function() {

    let adminId="Mock";
    let companyId="Mock";
      var result= await announcementService.verifyCredentials(adminId,companyId);
    expect(result).to.be.true;
  });

});


/*describe('Firestore Function', function () {
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
});*/

