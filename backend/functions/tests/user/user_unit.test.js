var chai = require("chai");
var expect = chai.expect;

var service = require("../../services/user/user.service");
var auth0 = require("../../services/user/auth0");
var auth0Client = auth0Client;
var firebase = require("../../services/user/firebase");
var firebaseClient = firebaseClient;

describe('Tests', function(){
    it('Sign in', function(){
        expect(auth0Client.signIn());
    });
});