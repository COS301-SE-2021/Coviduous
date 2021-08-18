var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();
const uuid = require("uuid");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('Create user unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .post('/api/users')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty userId', function(done) {
        let req = {
            userId: "",
            type: "USER",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: "test-000"
        };

        chai.request(server)
            .post('/api/users')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty type', function(done) {
        let req = {
            userId: "test-000",
            type: "",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: "test-000"
        };

        chai.request(server)
            .post('/api/users')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if incorrect type', function(done) {
        let req = {
            userId: "test-000",
            type: "INCORRECT TYPE",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: "test-000"
        };

      chai.request(server)
          .post('/api/users')
          .send(req)
          .end((err, res) => {
              should.exist(res);
              res.should.have.status(400);
              console.log(res.body);
              done();
          });
    });
 
    it('Return 400 if empty company name for admin user', function(done) {
        let req = {
            userId: "test-000",
            type: "ADMIN",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "",
            companyAddress: "test-000"
        };

        chai.request(server)
            .post('/api/users')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty company address for admin user', function(done) {
        let req = {
            userId: "test-000",
            type: "ADMIN",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: ""
        };

        chai.request(server)
            .post('/api/users')
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
            type: "ADMIN",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: "test-000"
        };
 
        chai.request(server)
            .post('/api/users')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                //done();
            });
    })
 });
 
describe('Delete user unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .delete('/api/users')
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
            userId: "USR-" + uuid.v4(),
            type: "ADMIN",
            firstName: "test-000",
            lastName: "test-000",
            email: "test-000",
            userName: "test-000",
            companyId: "test-000",
            companyName: "test-000",
            companyAddress: "test-000"
        };
 
        chai.request(server)
            .post('/api/users')
            .send(req)
            .end((err, res) => {
                //console.log(res.body);
                let req2 = {
                    userId: res.body.data.userId
                };
                //console.log(req2);
 
                chai.request(server)
                    .delete('/api/users')
                    .send(req2).end((err, res) => {
                         should.exist(res);
                         res.should.have.status(200);
                         //console.log(res.body);
                         //done();
                    });
            });
    });
});
 
describe('Get users unit tests', function() {
    it('Return 200 if retrieval is successful', function() {
        chai.request(server)
            .get('/api/users')
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                //console.log(res.body);
                //done();
            });
    });
});