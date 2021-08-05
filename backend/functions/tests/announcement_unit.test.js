var announcement=require("../subsystems/announcements.js");
var chai=require("chai");
var expect=chai.expect;
var obj=new announcement();

describe('Tests', function(){
    
    it('Unit test1',function(){
        expect(obj.add(1,2)).to.be.equal(3);
    })
});

