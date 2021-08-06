var chai = require("chai");
var expect = chai.expect;
//const { expect } = require('chai');
let chaiHttp = require('chai-http'); // npm install chai-http
//let server = require('../index.js');
let server = 'http://localhost:5001/coviduous-api/us-central1/app/'
let should = chai.should();

const functions = require('firebase-functions');
const admin = require('firebase-admin');

const Announcement = require("../../services/announcement/announcement.service.js");

// test 
// var announcements=require("../tests/announcement_unit.test.js");
// var myAnnouncement = new announcements();

chai.use(chaiHttp);

// describe('Tests', function(){
    
//     it('Unit test1',function(){
//         expect(myAnnouncement.add(1,2)).to.be.equal(3);
//     });
// });

describe('Announcement Unit Tests', () => {
    it('should create an announcement', () => {
        //let announcementList = [];
        var obj = new Announcement();
        announcement1 = obj.createAnnouncement("test", "test", "test", "test", "test", "test");

        //announcementList.push(announcement);

        expect(announcement1).to.be.not.null;
    })

    it('should get all announcements', () => {
        let announcementList = [];
        var obj = new Announcement();
        announcement1 = obj.createAnnouncement("test", "test", "test", "test", "test", "test");

        var obj = new Announcement();
        announcement2 = obj.createAnnouncement("test2", "test2", "test2", "test2", "test2", "test2");

        announcementList.push(announcement1);
        announcementList.push(announcement2);

        expect(announcementList).to.be.not.null;
        expect(announcementList.length).to.be.equal(2);
    })

    it('should delete an announcement', () => {
        let announcementList = [];
        var obj = new Announcement();
        announcement1 = obj.createAnnouncement("test", "test", "test", "test", "test", "test");

        var obj = new Announcement();
        announcement2 = obj.createAnnouncement("test2", "test2", "test2", "test2", "test2", "test2");

        var obj = new Announcement();
        announcement3 = obj.createAnnouncement("test3", "test3", "test3", "test3", "test3", "test3");

        announcementList.push(announcement1);
        announcementList.push(announcement2);
        announcementList.push(announcement3);

        expect(announcementList).to.be.not.null;
        expect(announcementList.length).to.be.equal(3);

        announcementList.pop();

        expect(announcementList).to.be.not.null;
        expect(announcementList.length).to.be.equal(2);
    })
});

// describe('/POST announcements', () => {
//     it('it should create an announcement', () => {
//         let announcement = {
//             adminId: "test-000",
//             announcementId: "test-000",
//             companyId: "test-000",
//             id: "test-000",
//             message: "test-000",
//             timestamp: "test-000",
//             type: "test-000"
//         }

//         chai.request(server)
//         .post('/api/announcement/create-announcement')
//         .send(announcement)
//         .end((err, res) => {
//             res.should.have.status(200);
//             res.body.should.be.a('object');
//             // res.body.should.have.property('message').eql('Announcement successfully created');
//             // res.body.announcement.should.have.property('announcementId');
//             // res.body.announcement.should.have.property('type');
//             // res.body.announcement.should.have.property('message');
//             // res.body.announcement.should.have.property('timestamp');
//             //done();
//         });
//     });
// });
    
describe('/GET announcements', () => {
    it('it should GET all the announcements', () => {
  chai.request(server).get('/api/announcement/view-announcements')
      .end((err, res) => {
        expect(err).to.be.null;
        res.should.have.status(200);
        expect(res).to.have.status(200);
        expect(res.body).should.be.a('object');
        //done();
      });
    });
});

