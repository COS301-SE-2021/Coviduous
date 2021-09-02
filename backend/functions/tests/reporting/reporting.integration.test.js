var chai = require("chai");
var expect = chai.expect;
//const { expect } = require('chai');
let chaiHttp = require('chai-http'); // npm install chai-http
//let server = require('../index.js');
let server = 'http://localhost:5002/coviduous-api/us-central1/app/'
let should = chai.should();

chai.use(chaiHttp);

describe('/POST notifications', () => {
    it('it should create an notification', () => {
        let notification = {
            userId: "test-000",
            userEmail: "test-000",
            subject: "test-000",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000"
        }

        chai.request(server)
        .post('/api/reporting/health/sick-employees/')
        .send(notification)
        .end((err, res) => {
            res.should.have.status(200);
            res.body.should.be.a('object');
            res.body.should.have.property('message').eql('Notification successfully created');
            //done();
        });
    });
});

describe('/DELETE notifications', () => {
    it('should DELETE a notification', function() {
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
            .post('/api/reporting/health/sick-employees')
            .send(req)
            .end((err, res) => {
                console.log(res.body);
                let req2 = {
                    notificationId: res.body.data.notificationId
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
    
describe('/GET notifications', () => {
    it('it should GET all the notifications', () => {
  chai.request(server).get('/api/reporting/health/sick-employees/')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(200);
        expect(res.body).should.be.a('object');
        //done();
      })//.catch(done);
    });
});