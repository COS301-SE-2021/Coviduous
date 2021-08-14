var chai = require("chai");
var expect = chai.expect;
var uuid = require("uuid"); // npm install uuid
var triggers = require('../triggers.js');
var firebasemock = require('firebase-mock'); // npm install firebase-mock --save-dev
const { viewNotificationsUserEmail } = require("../../services/notification/notification.controller.js");
var mockauth = new firebasemock.MockFirebase();
var mockfirestore = new firebasemock.MockFirestore();

var mocksdk = firebasemock.MockFirebaseSdk(null, function() {
  return mockauth;
}, function() {
  return mockfirestore;
});

var mockapp = mocksdk.initializeApp();
let server = 'http://localhost:5001/coviduous-api/us-central1/app/';


describe('Create notification unit test', function() {
  it('Return 400 if request is empty', function (done) {
      chai.request(server)
          .post('/api/notification')
          .send(null)
          .end((err, res) => {
              should.exist(res);
              res.should.have.status(400);
              console.log(res.body);
              done();
          });
  });
  it('Return 400 if empty subject', function(done) {
    let req = {
      subject:'', 
      message:'Check the covid update',  
      userEmail:'nku@gmail.com', 
      adminId: 'ADMIN-ID',
      companyId: 'COMPANY-ID'
    };

    chai.request(server)
        .post('/api/notification')
        .send(req)
        .end((err, res) => {
            should.exist(res);
            res.should.have.status(400);
            console.log(res.body);
            done();
        });

      });
      it('Return 400 if empty message', function(done) {
        let req = {
          subject:'Covid TEST', 
          message:'',  
          userEmail:'nku@gmail.com', 
          adminId: 'ADMIN-ID',
          companyId: 'COMPANY-ID'
        };
        chai.request(server)
            .post('/api/notification')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
     });
     it('Return 400 if empty userEmail', function(done) {
      let req = {
        subject:'Covid TEST', 
        message:'Check the covid update',  
        userEmail:'', 
        adminId: 'ADMIN-ID',
        companyId: 'COMPANY-ID'
      };
      chai.request(server)
          .post('/api/notification')
          .send(req)
          .end((err, res) => {
              should.exist(res);
              res.should.have.status(400);
              console.log(res.body);
              done();
          });
   });
   it('Return 400 if empty adminID', function(done) {
    let req = {
      subject:'Covid TEST', 
      message:'Check the covid update',  
      userEmail:'nku@gmail.com', 
      adminId: '',
      companyId: 'COMPANY-ID'
    };
    chai.request(server)
        .post('/api/notification')
        .send(req)
        .end((err, res) => {
            should.exist(res);
            res.should.have.status(400);
            console.log(res.body);
            done();
        });
 });
 it('Return 400 if empty companyId', function(done) {
  let req = {
    subject:'Covid TEST', 
    message:'Check the covid update',  
    userEmail:'nku@gmail.com', 
    adminId: 'ADMIN-ID',
    companyId: ''
  };
  chai.request(server)
      .post('/api/notification')
      .send(req)
      .end((err, res) => {
          should.exist(res);
          res.should.have.status(400);
          console.log(res.body);
          done();
      });
});

it('Return 200 if creation successful', function(done) {
  let req = {
    subject:'Covid TEST', 
    message:'Check the covid update',  
    userEmail:'nku@gmail.com', 
    adminId: 'ADMIN-ID',
    companyId: 'COM-ID'
  };

  chai.request(server)
      .post('/api/notification')
      .send(req)
      .end((err, res) => {
          should.exist(res);
          res.should.have.status(200);
          console.log(res.body);
          done();
      });
});

});

   

















  




  /*it('create notification', function() {
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
});*/
