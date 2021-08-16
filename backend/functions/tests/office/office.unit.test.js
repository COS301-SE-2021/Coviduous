var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('Create office booking unit tests', function() {
    it('Return 400 if request is empty', function (done) {
        chai.request(server)
            .post('/api/office')
            .send(null)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
    it('Return 400 if empty desk number', function(done) {
        let req = {
            deskNumber: "",
            floorPlanNumber: "test-000", 
            floorNumber: "test-000",
            roomNumber: "test-000", 
            timestamp: "test-000", 
            userId: "test-000", 
            companyId: "test-000"
        };

        chai.request(server)
            .post('/api/office')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                //console.log(res.body);
                done();
            });
    });
 
//     it('Return 400 if empty floorplan number', function(done) {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "", 
//             floorNumber: "test-000",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };

//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 console.log(res.body);
//                 done();
//             });
//     });

//     it('Return 400 if empty floor number', function(done) {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };

//       chai.request(server)
//           .post('/api/office')
//           .send(req)
//           .end((err, res) => {
//               should.exist(res);
//               res.should.have.status(400);
//               console.log(res.body);
//               done();
//           });
//     });
 
//     it('Return 400 if empty room number', function(done) {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "test-000",
//             roomNumber: "", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };

//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 console.log(res.body);
//                 done();
//             });
//     });

//     it('Return 400 if empty user ID', function(done) {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "test-000",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "", 
//             companyId: "test-000"
//         };

//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 console.log(res.body);
//                 done();
//             });
//     });
 
//     it('Return 400 if empty company ID', function(done) {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "test-000",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };

//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 console.log(res.body);
//                 done();
//             });
//     });
 
//     it('Return 200 if creation successful', function() {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "test-000",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };
 
//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(200);
//                 console.log(res.body);
//                 //done();
//             });
//     })
//  });
 
//  describe('Delete office booking unit tests', function() {
//     it('Return 400 if request is empty', function(done) {
//         chai.request(server)
//             .delete('/api/office')
//             .send(null)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(400);
//                 //console.log(res.body);
//                 done();
//             });
//     });
 
//     it('Return 200 if deletion is successful', function() {
//         let req = {
//             deskNumber: "test-000",
//             floorPlanNumber: "test-000", 
//             floorNumber: "test-000",
//             roomNumber: "test-000", 
//             timestamp: "test-000", 
//             userId: "test-000", 
//             companyId: "test-000"
//         };
 
//         chai.request(server)
//             .post('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 console.log(res.body);
//                 let req2 = {
//                     bookingNumber: res.body.data.bookingNumber
//                 };
 
//                 chai.request(server)
//                     .delete('/api/office')
//                     .send(req2).end((err, res) => {
//                          should.exist(res);
//                          res.should.have.status(200);
//                          //console.log(res.body);
//                          //done();
//                     });
//             });
//     });
 });
 
//  describe('Get office booking unit tests', function() {
//     it('Return 200 if retrieval is successful', function() {
//         let req = {
//             userId: 'test-000'
//         };

//         chai.request(server)
//             .get('/api/office')
//             .send(req)
//             .end((err, res) => {
//                 should.exist(res);
//                 res.should.have.status(200);
//                 //console.log(res.body);
//                 //done();
//             });
//     });
//  });