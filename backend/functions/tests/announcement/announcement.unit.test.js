var chai = require("chai");
var chaiHttp = require("chai-http");
var expect = chai.expect;
var should = chai.should();

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('Create announcement unit tests', function() {
   it('Return 400 if request is empty', function (done) {
       chai.request(server)
           .post('/api/announcements')
           .send(null)
           .end((err, res) => {
               should.exist(res);
               res.should.have.status(400);
               console.log(res.body);
               done();
           });
   });

    it('Return 400 if empty type', function(done) {
        let req = {
            type: '',
            message: 'message',
            adminId: 'ADMIN-ID',
            companyId: 'COMPANY-ID',
        };

        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if incorrect type', function(done) {
        let req = {
            type: 'NOT A REAL TYPE',
            message: 'message',
            adminId: 'ADMIN-ID',
            companyId: 'COMPANY-ID',
        };

        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if empty message', function(done) {
        let req = {
            type: 'GENERAL',
            message: '',
            adminId: 'ADMIN-ID',
            companyId: 'COMPANY-ID',
        };

        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if empty admin ID', function(done) {
        let req = {
            type: 'GENERAL',
            message: 'message',
            adminId: '',
            companyId: 'COMPANY-ID',
        };

        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

    it('Return 400 if empty company ID', function(done) {
        let req = {
            type: 'GENERAL',
            message: 'message',
            adminId: 'ADMIN-ID',
            companyId: '',
        };

        chai.request(server)
            .post('/api/announcements')
            .send(req)
            .end((err, res) => {
                should.exist(res);
                res.should.have.status(400);
                console.log(res.body);
                done();
            });
    });

   it('Return 200 if creation successful', function(done) {
       let req = {
           type: 'GENERAL',
           message: 'New announcement',
           adminId: 'ADMIN-ID',
           companyId: 'COMPANY-ID',
       };

       chai.request(server)
           .post('/api/announcements')
           .send(req)
           .end((err, res) => {
               should.exist(res);
               res.should.have.status(200);
               console.log(res.body);
               done();
           });
   })
});

describe('Delete announcement unit tests', function() {
   it('Return 400 if request is empty', function(done) {
       chai.request(server)
           .delete('/api/announcements')
           .send(null)
           .end((err, res) => {
               should.exist(res);
               res.should.have.status(400);
               console.log(res.body);
               done();
           });
   });

   it('Return 200 if deletion is successful', function(done) {
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
               console.log(res.body);
               let req2 = {
                   announcementId: res.body.data.announcementId
               };

               chai.request(server)
                   .delete('/api/announcements')
                   .send(req2).end((err, res) => {
                        should.exist(res);
                        res.should.have.status(200);
                        console.log(res.body);
                        done();
                   });
           });
   });
});

describe('Get announcement unit tests', function() {
   it('Return 200 if retrieval is successful', function(done) {
       chai.request(server)
           .get('/api/announcements')
           .send()
           .end((err, res) => {
               should.exist(res);
               res.should.have.status(200);
               console.log(res.body);
               done();
           });
   });
});

