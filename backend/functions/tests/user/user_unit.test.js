const chai = require("chai");
const chaiHttp = require("chai-http");
const expect = chai.expect;
const User = require("../../services/user/user.service");
//const should = chai.should();

let server = 'http://localhost:5001/coviduous-api/us-central1/app/';

chai.use(chaiHttp);

describe('User unit tests', function(){
    const obj = new User();
    it('Should create user', function(){
        let user1 = obj.createUser("testEmail@email.com", "testPassword123");

        expect(user1).to.not.be.null;
        expect(user1).to.not.be.equal('undefined');
    });
});

describe('/POST user', () => {
    it('Should create a new user account', () => {
        chai.request(server).post('/api/users')
            .end((err, res) => {
                expect(err).to.be.null;
                res.should.have.status(200);
                expect(res).to.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });
});

describe('/GET user', () => {
    it('Should sign a user in', () => {
        chai.request(server).get('/api/users')
            .end((err, res) => {
                console.log("Response: " + res);
                expect(err).to.be.null;
                res.should.have.status(200);
                expect(res).to.have.status(200);
                expect(res.body).should.be.a('object');
            });
    });
});