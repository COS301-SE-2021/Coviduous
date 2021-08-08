const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const should = chai.should();
const User = require("../../models/user.model");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('User unit tests', function(){
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

    it('Sign out directly', function(){
       userObj1.signUserOut()
           .then((userRes) => {
              expect(userRes).to.be.true;
           });
    });

    it('/POST user to create new account', () => {
        let user = {
            email: "testemail2@email.com",
            password: "123456"
        }

        chai.request(server)
            .post('/api/users')
            .send(user)
            .end((err, res) => {
                expect(err).to.be.null;
                should.exist(res.body);
                res.should.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });

    it('/GET user to sign in', () => {
        let user = {
            email: "testemail2@email.com",
            password: "123456"
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
});