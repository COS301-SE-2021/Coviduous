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
let devDatabase = require("../../config/firestore.database.js");
const floorplanService = require("../../services/floorplan/floorplan.service.js");
// Set the database you want to work with the test or production database
floorplanService.setDatabse(devDatabase);

describe('Floorplan unit tests', function(){
    it('Create Floor Plan', function(){
        expect(floorplanService.createFloorPlanMock('Test-83w3',{
            message: 'floorplan successfully created',
            data: 'test'
          })).to.be.true;
    });

});