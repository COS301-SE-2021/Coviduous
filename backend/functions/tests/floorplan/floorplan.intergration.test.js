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
var expect = chai.expect;
var should = chai.should();
var chaiHttp = require("chai-http");
chai.use(chaiHttp);
let server = 'http://localhost:5002/coviduous-api/us-central1/app/';
let devDatabase = require("../../config/floorplan.firestore.database.js");
const floorplanService = require("../../services/floorplan/floorplan.controller.js");
// Set the database you want to work with the test or production database
floorplanService.setDatabase(devDatabase);
let db= new devDatabase();


//Tests to check if database queries / database file for firestore perform therequested operations
describe('Floorplan intergration tests', function(){
  it('Create Floorplan', function(done) {
    let req = {
      numFloors: "3",
      adminId: "ADMIN-1",
      companyId: "CID-1"
      };
    chai.request(server)
        .post('/api/floorplan') 
        .send(req)
        .end((err, res) => {
            should.exist(res);
            res.should.have.status(200);
            console.log(res.body);
            done();
        });
});

    it('Create Floor Plan', function(){
       db.createFloorPlan('test-000',{
        adminId: "test-000",
        floorplanNumber: "test-000",
        companyId: "test-000",
        numFloors: "test-000"
        })
        expect(db.getIfLastQuerySucceeded()).to.be.true;
        
    });

    it('Create Floor', function(){
      db.createFloor('test-0110',{
       adminId: "test-000",
       floorplanNumber: "test-000",
       companyId: "test-000",
       numFloors: "test-000"
       })
       expect(db.getIfLastQuerySucceeded()).to.be.true;
       
   });

    it('Create Room', function(){
      db.createRoom('test-0880',{
       adminId: "test-000",
       floorplanNumber: "test-000",
       companyId: "test-000",
       numFloors: "test-000"
       })
       expect(db.getIfLastQuerySucceeded()).to.be.true;
       
   });

});

