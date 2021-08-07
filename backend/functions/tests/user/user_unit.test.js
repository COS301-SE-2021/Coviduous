const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const User = require("../../models/user.model");

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('User unit tests', function(){
    const userObj = new User();
    it('Should create user', function(){
        let userRes = userObj.createUser("testEmail@email.com", "testPassword123");

        expect(userRes).to.not.be.null;
        expect(userRes).to.not.be.equal('undefined');
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
                res.should.have.status(200);
                expect(res).to.have.status(200);
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
                console.log("Response: " + res);
                expect(err).to.be.null;
                res.should.have.status(200);
                expect(res).to.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });
});