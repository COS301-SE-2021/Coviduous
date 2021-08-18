var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

//using depenedency injection principles we inject the mock database into our notification service 
// that can be seen on the notifications.routes file

describe('Create notification unit tests', function() {
    it('mock create notifications', function(done) {
        let req = {
            notificationId: "test-000",
            userId: "test-000",
            userEmail: "test-000",
            subject: "test-000",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000"
          };
        chai.request(server)
            .post('/api/mock/notifications') //This route is specific for our mocking services, please open the notification.route file to see the depency injection of the mockfirebase service
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });

    it('mock delete notifications', function(done) {
        let req = {
            notificationId: "test-000",
            userId: "test-000",
            userEmail: "test-000",
            subject: "test-000",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000"
          };
        chai.request(server)
            .delete('/api/mock/notifications') //This route is specific for our mocking services, please open the notification.route file to see the depency injection of the mockfirebase service
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });


    it('mock view notifications using email', function(done) {
        let req = {
            notificationId: "test-000",
            userId: "test-000",
            userEmail: "test-000",
            subject: "test-000",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000"
          };
        chai.request(server)
            .post('/api/mock/notifications/user-email') //This route is specific for our mocking services, please open the notification.route file to see the depency injection of the mockfirebase service
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });


    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .post('/api/notifications')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty subject', function(done) {
        let req = {
          notificationId: "test-000",
          userId: "test-000",
          userEmail: "test-000",
          subject: "",
          message: "test-000",
          timestamp: "test-000",
          adminId: "test-000",
          companyId: "test-000"
        };

        chai.request(server)
            .post('/api/notifications')
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
          userId: "test-000",
          userEmail: "test-000",
          subject: "test-000",
          message: "",
          timestamp: "test-000",
          adminId: "test-000",
          companyId: "test-000"
        };

        chai.request(server)
            .post('/api/notifications')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if empty user ID', function(done) {
      let req = {
        userId: "",
        userEmail: "test-000",
        subject: "test-000",
        message: "test-000",
        timestamp: "test-000",
        adminId: "test-000",
        companyId: "test-000"
      };

      chai.request(server)
          .post('/api/notifications')
          .send(req)
          .end((err, res) => {
              should.exist(res);
              res.should.have.status(400);
              console.log(res.body);
              done();
          });
    });
 
    it('Return 400 if empty admin ID', function(done) {
        let req = {
          userId: "test-000",
          userEmail: "test-000",
          subject: "test-000",
          message: "test-000",
          timestamp: "test-000",
          adminId: "",
          companyId: "test-000"
        };

        chai.request(server)
            .post('/api/notifications')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty company ID', function(done) {
        let req = {
          userId: "test-000",
          userEmail: "test-000",
          subject: "test-000",
          message: "test-000",
          timestamp: "test-000",
          adminId: "test-000",
          companyId: ""
        };

        chai.request(server)
            .post('/api/notifications')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 
    it('Return 200 if creation successful', function() {
        let req = {
            userId: "test-000",
            userEmail: "test-000",
            subject: "test-000",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000"
        };
 
        chai.request(server)
            .post('/api/notifications')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                //done();
            });
    })
 });
 
 describe('Delete notification unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .delete('/api/notifications')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 200 if deletion is successful', function() {
       let req = {
          userId: "test-000",
          userEmail: "test-000",
          subject: "test-000",
          message: "test-000",
          timestamp: "test-000",
          adminId: "test-000",
          companyId: "test-000"
       };
 
        chai.request(server)
            .post('/api/notifications')
            .send(req)
            .end((err, res) => {
                console.log(res.body);
                let req2 = {
                    notificationId: res.body.data.notificationId
                };
 
                chai.request(server)
                    .delete('/api/notifications')
                    .send(req2).end((err, res) => {
                         should.exist(res);
                         res.should.have.status(200);
                         //console.log(res.body);
                         //done();
                    });
            });
    });
 });
 
 describe('Get notification unit tests', function() {
    it('Return 200 if retrieval is successful', function() {
        chai.request(server)
            .get('/api/notifications')
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                //console.log(res.body);
                //done();
            });
    });
 });
