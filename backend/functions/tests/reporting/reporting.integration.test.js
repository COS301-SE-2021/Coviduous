var chai = require("chai");
var expect = chai.expect;
//const { expect } = require('chai');
let chaiHttp = require('chai-http'); // npm install chai-http
//let server = require('../index.js');
let server = 'http://localhost:5002/coviduous-api/us-central1/app/'
let should = chai.should();

chai.use(chaiHttp);

describe('/POST sick employees', () => {
    it('it should create a sick employee', () => {
        let sickEmployee = {
            userId: "test-000",
            userEmail: "test-000",
            timeOfDiagnosis: "test-000",
            companyId: "test-000"
        }

        chai.request(server)
        .post('/api/reporting/health/sick-employees/')
        .send(sickEmployee)
        .end((err, res) => {
            res.should.have.status(200);
            res.body.should.be.a('object');
            res.body.should.have.property('message').eql('Sick employee successfully created');
            //done();
        });
    });
});

describe('/DELETE sick employees', () => {
    it('should DELETE a sick employee', function() {
        let req = {
            userId: "test-000",
            userEmail: "test-000",
            timeOfDiagnosis: "test-000",
            companyId: "test-000"
        };
    
        chai.request(server)
            .post('/api/reporting/health/sick-employees')
            .send(req)
            .end((err, res) => {
                console.log(res.body);
                let req2 = {
                    userId: res.body.data.userId
                };
    
                chai.request(server)
                    .delete('/api/reporting/health/sick-employees')
                    .send(req2).end((err, res) => {
                        should.exist(res);
                        res.should.have.status(200);
                        console.log(res.body);
                        //done();
                    });
            });
    });
}); 

// describe('/GET sick employees', () => {
//     it('it should GET all the sick employees', () => {
//   chai.request(server).get('/api/reporting/health/sick-employees/') // change to post - /view
//       .end((err, res) => {
//         expect(err).to.be.null;
//         expect(res).to.have.status(200);
//         expect(res.body).should.be.a('object');
//         //done();
//       })//.catch(done);
//     });
// });