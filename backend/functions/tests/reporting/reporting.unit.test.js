var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();
const uuid = require("uuid");

let server = 'http://localhost:5002/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('Create sick employee unit tests', function() {
    it('Return 400 if request is empty', function(done) {
        chai.request(server)
            .post('/api/reporting/health/sick-employees')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty user ID', function(done) {
        let req = {
            userId: "",
            userEmail: "test-000",
            timeOfDiagnosis: "test-000",
            companyId: "test-000"
        };

        chai.request(server)
            .post('/api/reporting/health/sick-employees')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty user email', function(done) {
        let req = {
            userId: "test-000",
            userEmail: "",
            timeOfDiagnosis: "test-000",
            companyId: "test-000"
        };

        chai.request(server)
            .post('/api/reporting/health/sick-employees')
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
            timeOfDiagnosis: "test-000",
            companyId: ""
        };

        chai.request(server)
            .post('/api/reporting/health/sick-employees')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });
 });
 
//  describe('Delete sick employee unit tests', function() {
//     it('Return 400 if request is empty', function(done) {
//         chai.request(server)
//             .delete('/api/reporting/health/sick-employees')
//             .send(null)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 //console.log(res.body);
//                 done();
//             });
//     });
 
//     it('Return 200 if deletion is successful', function() {
        // let req = {
        //     userId: "test-000",
        //     userEmail: "test-000",
        //     timeOfDiagnosis: "test-000",
        //     companyId: "test-000"
        // };
 
//         chai.request(server)
//             .post('/api/reporting/health/sick-employees')
//             .send(req)
//             .end((err, res) => {
//                 //console.log(res.body);
//                 let req2 = {
//                     userId: res.body.data.userId
//                 };
//                 //console.log(req2);
 
//                 chai.request(server)
//                     .delete('/api/users')
//                     .send(req2).end((err, res) => {
//                          should.exist(res);
//                          res.should.have.status(200);
//                          //console.log(res.body);
//                          //done();
//                     });
//             });
//     });
// });

//  describe('Get sick employees unit tests', function() {
//     it('Return 200 if retrieval is successful', function() {
//         chai.request(server)
//             .get('/api/reporting/health/sick-employees') // change to post - /view
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(200);
//                 //console.log(res.body);
//                 //done();
//             });
//     });
// });