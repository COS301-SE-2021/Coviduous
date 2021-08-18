const admin = require('firebase-admin');
const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors({ origin: true }));
var serviceAccount = require("../../permissions.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://fir-api-9a206..firebaseio.com"
}); 
var chai = require("chai");
var chaiHttp = require("chai-http");
chai.use(chaiHttp);
var should = chai.should();
let server = 'http://localhost:5001/coviduous-api/us-central1/app/';
let devDatabase = require("../../config/health.firestore.database.js");
const healthService = require("../../services/health/health.controller.js");
// Set the database you want to work with the test or production database
healthService.setDatabase(devDatabase);


//Intergration tests to test the heath service using the production database health.firestore.database.js
describe('Health Service intergration tests', function(){

    it('Create Health Check', function(done) {
        let req = {
            userId: "USR-187f5",
            name: "test",
            surname: "test",
            email: "test@1243",
            phoneNumber: "08456382902",
            temperature: "36.6",
            fever: "1",
            cough: "0",
            sore_throat: "1",
            chills: "0",
            aches: "0",
            nausea: "0",
            shortness_of_breath: "0",
            loss_of_taste: "0",
            sixFeetContact: "0",
            head_ache:"1",
            testedPositive: "0",
            travelled: "0",
            d_t_prediction: "positive",
            dt_accuracy: 0.9663865546218487,
            naive_prediction: "positive",
            nb_accuracy: 0.9663865546218487
          };
        chai.request(server)
            .post('/api/health/health-check') 
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });

    it('Permission Request', function(done) {
        let req = {
            adminId:"ADMIN-1",
            userId:"USR-187f5",
            userEmail:"tets@890h",
            adminEmail:"njabuloskosana24@gmail.com",
            permissionId:"PRMN-6ea11b3f-d93f-42e1-98ec-a23588577eb8",
            companyId:"CID-1",
            reason:"Need to access the office",
            shiftNumber:"SHT-084563829vjkbns02"
          };
        chai.request(server)
            .post('/api/health/permissions/permission-request') 
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });


    it('Report Infection', function(done) {
        let req = {
            userId: "USR-1",
            userEmail:"test@7893",
            adminEmail:"njabuloskosana24@gmail.com",
            adminId:"ADMIN-1",
            companyId:"CID-1"
          };
        chai.request(server)
            .post('/api/health/report-infection') 
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(200);
                console.log(res.body);
                done();
            });
    });
    
});