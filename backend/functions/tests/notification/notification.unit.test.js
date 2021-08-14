var chai = require("chai");
var expect = chai.expect;
//var uuid = require("uuid"); // npm install uuid
let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

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
describe('Delete notification unit tests', function() {
  it('Return 400 if request is empty', function(done) {
      chai.request(server)
          .delete('/api/notification')
          .send(null)
          .end((err, res) => {
              should.exist(res);
              res.should.have.status(400);
              console.log(res.body);
              done();
          });
  });

  it('Return 400 if empty notificationId', function(done) {
    let req = {
      notificationId:''
    };
    chai.request(server)
        .delete('/api/notification')
        .send(req)
        .end((err, res) => {
            should.exist(res);
            res.should.have.status(400);
            console.log(res.body);
            done();
        });
  });
  it('Return 200 if deletion is successful', function(done) {
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
             console.log(res.body);
             let req2 = {
              notificationId: res.body.notificationId,
             };

             chai.request(server)
                 .delete('/api/notification')
                 .send(req2).end((err, res) => {
                      should.exist(res);
                      res.should.have.status(200);
                      console.log(res.body);
                      done();
                 });
         });
 });
});
