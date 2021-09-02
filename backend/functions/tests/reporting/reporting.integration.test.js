// var chai = require("chai");
// var expect = chai.expect;
// //const { expect } = require('chai');
// let chaiHttp = require('chai-http'); // npm install chai-http
// //let server = require('../index.js');
// let server = 'http://localhost:5002/coviduous-api/us-central1/app/'
// let should = chai.should();
// const NotificationService = require("../../services/notification/notification.controller.js");

//const functions = require('firebase-functions');
//const admin = require('firebase-admin');

//const Notification = require("../../models/notification.model.js");
//const notificationDB = require("../../config/notification.firestore.database.js");

//chai.use(chaiHttp);

//needs to be correctly asserted but does deliver an email
/*describe('Notification Sending Email Notification', function() {
    it('Send User Email', async function() {
        let message="Hey There!";
        let subject="Test Email";
        let userEmail = "njabuloskosana24@gmail.com";
        expect(await NotificationService.sendUserEmail(userEmail,subject,message)).to.equal(true);
        

    });
});*/

// describe('/POST notifications', () => {
//     it('it should create an notification', () => {
//         let notification = {
//             // notificationId: "test-000",
//             userId: "test-000",
//             userEmail: "test-000",
//             subject: "test-000",
//             message: "test-000",
//             timestamp: "test-000",
//             adminId: "test-000",
//             companyId: "test-000"
//         }

//         chai.request(server)
//         .post('/api/notifications/')
//         .send(notification)
//         .end((err, res) => {
//             res.should.have.status(200);
//             res.body.should.be.a('object');
//             res.body.should.have.property('message').eql('Notification successfully created');
//             //done();
//         });
//     });
// });

// describe('/DELETE notifications', () => {
//     it('should DELETE a notification', function() {
//         let req = {
//             userId: "test-000",
//             userEmail: "test-000",
//             subject: "test-000",
//             message: "test-000",
//             timestamp: "test-000",
//             adminId: "test-000",
//             companyId: "test-000"
//         };
    
//         chai.request(server)
//             .post('/api/notifications')
//             .send(req)
//             .end((err, res) => {
//                 console.log(res.body);
//                 let req2 = {
//                     notificationId: res.body.data.notificationId
//                 };
    
//                 chai.request(server)
//                     .delete('/api/notifications')
//                     .send(req2).end((err, res) => {
//                         should.exist(res);
//                         res.should.have.status(200);
//                         console.log(res.body);
//                         //done();
//                     });
//             });
//     });
// }); 
    
// describe('/GET notifications', () => {
//     it('it should GET all the notifications', () => {
//   chai.request(server).get('/api/notifications/')
//       .end((err, res) => {
//         expect(err).to.be.null;
//         expect(res).to.have.status(200);
//         expect(res.body).should.be.a('object');
//         //done();
//       })//.catch(done);
//     });
// });