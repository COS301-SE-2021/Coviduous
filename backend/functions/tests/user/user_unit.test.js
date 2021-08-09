const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const should = chai.should();
const User = require("../../models/user.model");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);
let userObj = new User(true);

// This function allows tests to be delayed so that they're properly executed in order
function delay(interval) {
    return it('Should delay', done => {
        setTimeout(() => done(), interval)
    }).timeout(interval + 100)
}

describe('User unit tests - direct interaction with auth', function() {
    it('* User.createUser() function', function() {
        userObj.createUser("testEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    delay(1000);

    it('* User.signUserIn(), User.getCurrentUser(), and User.getEmail() functions', function() {
        userObj.signUserIn("testEmail@email.com", "testPassword123")
            .then((userRes) => {
                expect(userObj.getCurrentUser()).to.not.be.null;
                expect(userObj.getEmail()).to.not.be.null;
                expect(userRes).to.be.true;
            });
    });

    delay(1000);

    it('* User.createUser() function', function() {
        userObj.createUser("testEmail2@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    it('* User.updateUserEmail() function', function() {
        userObj.updateUserEmail("newEmail@email.com", "testEmail2@email.com", "testPassword123")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    delay(1000);

    it('* User.signUserOut() function', function(){
        userObj.signUserOut()
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });

    delay(1000);

    it('* User.sendPasswordReset() function', function() {
        userObj.sendPasswordReset("testEmail@email.com")
            .then((userRes) => {
                expect(userRes).to.be.true;
            });
    });
});

describe('User unit tests - interaction with auth and database over HTTP', function(){
    it('POST /api/users/signUp to create new user', () => {
        let user = {
            uid: "1",
            email: "testemail3@email.com",
            password: "123456"
        }

        chai.request(server)
            .post('/api/users/signUp')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    delay(1000);

    it('GET /api/users/signIn to sign in', () => {
        let user = {
            email: "testemail3@email.com",
            password: "123456"
        }

        chai.request(server)
            .get('/api/users/signIn')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    delay(1000);

    it('POST /api/users/updateDetails to update user details', () => {
        let user = {
            currentEmail: "testemail3@email.com",
            firstName: "Hello",
            lastName: "World",
            userType: "user"
        }

        chai.request(server)
            .post('/api/users/updateDetails')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    delay(1000);

    it('GET /api/users to retrieve user details', () => {
        let user = {
            email: "testemail3@email.com",
        }

        chai.request(server)
            .get('/api/users')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    delay(1000);

    it('POST /api/passwordReset to send password reset email', () => {
        let user = {
            email: "testemail3@email.com",
        }

        chai.request(server)
            .get('/api/passwordReset')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    delay(1000);

    it('POST /api/users/updateEmail to update user email', () => {
        let user = {
            newEmail: "updatedEmail@email.com",
            currentEmail: "testEmail3@email.com",
            password: "123456"
        }

        chai.request(server)
            .post('/api/users/updateEmail')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                console.log(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });
});