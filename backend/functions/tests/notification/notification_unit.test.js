let myClass= require("../notification/notification.controller.js");
let myObj = new myClass();
var chai = require("chai");
var expect = chai.expect;

describe("Test suit", function (){
    it("Test the delete notification method", function () {
        expect(myObj.deleteNotification(ID)).to.be.equal("Notification successfully deleted");
    })
})
