const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const should = chai.should();
const User = require("../../models/user.model");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('User unit tests', function(){
    const userObj = new User();
    it('Should create user', async function(){
        let userRes = userObj.createUser("testEmail@email.com", "testPassword123")
            .then(() => {
                expect(userRes).to.be.true;
                userObj.signUserOut();
                console.log("test");
            });
    });
});

describe('/POST user', () => {
    it('Should create a new user account', () => {
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
});

describe('/GET user', () => {
    it('Should sign an existing user in', () => {
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