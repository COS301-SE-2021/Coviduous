var chai = require("chai");
var expect = chai.expect;
//const { expect } = require('chai');
let chaiHttp = require('chai-http'); // npm install chai-http
//let server = require('../index.js');
let server = 'http://localhost:5002/coviduous-api/us-central1/app/'
let should = chai.should();

//const functions = require('firebase-functions');
//const admin = require('firebase-admin');

//const Announcement = require("../../models/announcement.model.js");
//const announcementDB = require("../../config/announcement.firestore.database.js");

chai.use(chaiHttp);

describe('/POST announcements', () => {
    it('it should create an announcement', () => {
        let announcement = {
            // announcementId: "test-000",
            type: "GENERAL",
            message: "test-000",
            timestamp: "test-000",
            adminId: "test-000",
            companyId: "test-000",
        }

        chai.request(server)
        .post('/api/announcements/')
        .send(announcement)
        .end((err, res) => {
            res.should.have.status(200);
            res.body.should.be.a('object');
            res.body.should.have.property('message').eql('Announcement successfully created');
            // res.body.data.should.have.property('announcementId');
            // res.body.data.should.have.property('type');
            // res.body.data.should.have.property('message');
            // res.body.data.should.have.property('timestamp');
            //done();
        });
    });
}); 

describe('/DELETE announcements', () => {
    it('should DELETE an announcement', function() {
        let req = {
            type: 'GENERAL',
            message: 'Announcement to be deleted',
            adminId: 'ADMIN-ID',
            companyId: 'COMPANY-ID',
        };
    
        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                //console.log(res.body);
                let req2 = {
                    announcementId: res.body.data.announcementId
                };
    
                chai.request(server)
                    .delete('/api/announcements')
                    .send(req2).end((err, res) => {
                        should.exist(res);
                        res.should.have.status(200);
                        //console.log(res.body);
                        //done();
                    });
            });
    });
}); 
    
describe('/GET announcements', () => {
    it('it should GET all the announcements', () => {
  chai.request(server).get('/api/announcements/')
      .end((err, res) => {
        expect(err).to.be.null;
        expect(res).to.have.status(200);
        expect(res.body).should.be.a('object');
        //done();
      })//.catch(done);
    });
});

// describe('Get all announcements', () => {
//     it('it should GET all the announcements', () => {
//         obj = announcementDB.viewAnnouncements()
//         .then((res) => {
//             expect(res).to.be.not.null;
//             expect(res).to.be.a('object');
//         });
//     });
// });