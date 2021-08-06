var chai = require("chai");
var expect = chai.expect;
var should = chai.should();

var service = require("../../services/user/mocks/user.service.mock");
var serviceRef = new service();

describe('User unit tests', function(){
    it('Sign in', function(){
        expect(serviceRef.signIn()).to.be.true;
    });

    it('View messages', function(){
        expect(serviceRef.viewMessages()).to.be.true;
    })

    it('Update email', function(){
        expect(serviceRef.updateEmail('test email')).to.be.true;
    })

    it('Sign out', function(){
        expect(serviceRef.signOut()).to.be.true;
    })
});