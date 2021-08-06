let myClass= require("../notification/notification.controller.js");
let myObj = new myClass();
var chai = require("chai");
var expect = chai.expect;
//not sure how to mock the database.
describe("Test suit", function (){
    it("Test the delete notification method", function () {
        expect(myObj.deleteNotification(req,res)).to.be.equal("Notification successfully deleted");
    })
    it("Test the create Notification method", function () {
        expect(myObj.createNotification(req,res)).to.be.equal("Notification successfully created");
    })
})
