var announcements=require("../tests/announcement_unit.test.js");
var myAnnouncement = new announcements();
var chai=require("chai");
var expect=chai.expect;

describe('Tests', function(){
    
    it('Unit test1',function(){
        expect(myAnnouncement.add(1,2)).to.be.equal(3);
    });
});

