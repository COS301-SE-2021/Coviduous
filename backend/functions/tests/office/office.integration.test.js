var chai = require("chai");
var expect = chai.expect;
//const { expect } = require('chai');
let chaiHttp = require('chai-http'); // npm install chai-http
//let server = require('../index.js');
let server = 'http://localhost:5001/coviduous-api/us-central1/app/'
let should = chai.should();

chai.use(chaiHttp);

describe('/POST office', () => {
    it('it should create an office booking', () => {
        let booking = {
            deskNumber: "test-000",
            floorPlanNumber: "test-000", 
            floorNumber: "test-000",
            roomNumber: "test-000", 
            timestamp: "test-000", 
            userId: "test-000", 
            companyId: "test-000"
        }

        chai.request(server)
        .post('/api/office')
        .send(booking)
        .end((err, res) => {
            res.should.have.status(200);
            res.body.should.be.a('object');
            res.body.should.have.property('message').eql('Office booking successfully created');
            //done();
        });
    });
});

describe('/DELETE office', () => {
    it('should DELETE an office booking', function() {
        let req = {
            deskNumber: "test-000",
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
                //console.log(res.body);
                let req2 = {
                    bookingNumber: res.body.data.bookingNumber
                };
  
                chai.request(server)
                    .delete('/api/office')
                    .send(req2).end((err, res) => {
                        should.exist(res);
                        res.should.have.status(200);
                        //console.log(res.body);
                        //done();
                    });
            });
    });
}); 
    
// describe('/GET office', () => {
//     it('it should GET all the bookings in the office based on userId', () => {
//         let req = {
//             userId: 'test-000'
//         };

//         chai.request(server)
//             .get('/api/office/view')
//             .send(req)
//             .end((err, res) => {
//                 expect(err).to.be.null;
//                 expect(res).to.have.status(200);
//                 expect(res.body).should.be.a('object');
//                 //done();
//             })//.catch(done);
//     });
// });