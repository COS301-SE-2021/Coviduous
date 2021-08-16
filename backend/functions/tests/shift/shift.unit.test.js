var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('Create shift unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .post('/api/shift')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty date', function(done) {
        let req = {
            date: "",
            startTime: "test-000",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: "CID-test"
        };

        chai.request(server)
            .post('/api/shift')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty start time', function(done) {
        let req = {
            date: "test-000",
            startTime: "",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: "CID-test"
        };

        chai.request(server)
            .post('/api/shift')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if empty end time', function(done) {
        let req = {
            date: "test-000",
            startTime: "test-000",
            endTime: "",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: "CID-test"
        };

      chai.request(server)
          .post('/api/shift')
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
            date: "test-000",
            startTime: "test-000",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "",
            companyId: "CID-test"
        };

        chai.request(server)
            .post('/api/shift')
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
            date: "test-000",
            startTime: "",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: ""
        };

        chai.request(server)
            .post('/api/shift')
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
            date: "test-000",
            startTime: "test-000",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: "CID-test"
        };
 
        chai.request(server)
            .post('/api/shift')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                //done();
            });
    })
});
 
describe('Delete shift unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .delete('/api/shift')
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
            date: "test-000",
            startTime: "test-000",
            endTime: "test-000",
            description: "test-000",
            floorNumber: "test-000",
            roomNumber: "test-000",
            groupNumber: "test-000",
            floorPlanNumber: "test-000",
            adminId: "AID-test",
            companyId: "CID-test"
        };
 
        chai.request(server)
            .post('/api/shift')
            .send(req)
            .end((err, res) => {
                console.log(res.body);
                let req2 = {
                    shiftId: res.body.data.shiftID
                };
                console.log(req2);
 
                chai.request(server)
                    .delete('/api/shift')
                    .send(req2)
                    .end((err, res) => {
                         should.exist(res);
                         res.should.have.status(200);
                         //console.log(res.body);
                         //done();
                    });
            });
    });
});
 
describe('Get shifts unit tests', function() {
    it('Return 200 if retrieval is successful', function() {
        chai.request(server)
            .get('/api/shift')
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                //console.log(res.body);
                //done();
            });
    });
});