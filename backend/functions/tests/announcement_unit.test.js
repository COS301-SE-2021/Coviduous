var announcements=require("../tests/announcement_unit.test.js");
var chai=require("chai");
var expect=chai.expect;

describe('Tests', function(){
    
    it('Unit test1',function(){
        expect(announcements.add(1,2)).to.be.equal(3);
    })
});

