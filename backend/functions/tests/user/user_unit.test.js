var chai = require("chai");
var expect = chai.expect;

var service = require("../../services/user/user.service");
var serviceRef = new service();

describe('Tests', function(){
    it('Sign in', function(){
        expect(serviceRef.signIn().to.be.equal(true));
    });

    it('View notification', function(){
        expect(serviceRef.viewNotifications().to.be.equal(true));
    })

    it('Sign out', function(){
        expect(serviceRef.signOut().to.be.equal(true));
    })
});