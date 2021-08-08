const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const should = chai.should();
const User = require("../../models/user.model");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('User unit tests - direct interaction with auth', function(){
    let userObj1 = new User(true);

    it('Create new user directly', function(){
        userObj1.createUser("testEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    it('Sign in directly', function(){
        userObj1.signUserIn("testEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    it('Update email directly', function(){
        userObj1.updateUserEmail("newEmail@email.com", "testEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    it('Get user credentials directly', function(){
        userObj1.createUser( "yetAnotherNewEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userObj1.getCurrentUser()).to.not.be.null;
                expect(userObj1.getEmail()).to.not.be.null;
                expect(userRes).to.be.true;
            });
    });


    it('Sign out directly', function(){
       userObj1.signUserOut()
           .then((userRes) => {
              expect(userRes).to.be.true;
           });
    });

    it('Create and send password reset email', function(){
        userObj1.createUser("capslock.cos301@gmail.com", "123456")
            .then(() => {
                userObj1.sendPasswordReset("capslock.cos301@gmail.com")
                    .then((userRes) => {
                        expect(userRes).to.be.true;
                    });
            });
    });
});

describe('User unit tests - interaction over HTTP', function(){
    it('POST /api/users/signUp to create new user', () => {
        let user = {
            uid: "1",
            email: "testemail2@email.com",
            password: "123456"
        }

        chai.request(server)
            .post('/api/users/signUp')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('GET /api/users/signIn to sign in', () => {
        let user = {
            email: "testemail2@email.com",
            password: "123456"
        }

        chai.request(server)
            .get('/api/users/signIn')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('POST /api/users/updateDetails to update user details', () => {
        let user = {
            currentEmail: "testemail2@email.com",
            firstName: "Hello",
            lastName: "World"
        }

        chai.request(server)
            .post('/api/users/updateDetails')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('GET /api/users to retrieve user details', () => {
        let user = {
            email: "testemail2@email.com",
        }

        chai.request(server)
            .get('/api/users')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('POST /api/passwordReset to send password reset email', () => {
        let user = {
            email: "testemail2@email.com",
        }

        chai.request(server)
            .get('/api/passwordReset')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('POST /api/users/updateEmail to update user email', () => {
        let user = {
            newEmail: "updatedEmail@email.com",
            currentEmail: "testemail2@email.com",
            password: "123456"
        }

        chai.request(server)
            .post('/api/users/updateEmail')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });
});