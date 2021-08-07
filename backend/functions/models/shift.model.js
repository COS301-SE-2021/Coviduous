class Shift {
    constructor(shiftID,startTime, endTime, description,groupNo,adminId,companyId)
    {
        this.shiftID = shiftID;
        this.description = description;
        this.startTime = startTime;
        this.endTime=endTime;
        this.groupNo= groupNo;
        this.companyId = companyId;
        this.adminId = adminId;
    }

    Shift(shiftID, startTime, endTime, description,groupNo,adminId,companyId) {
        return new Shift(shiftID, startTime, endTime, description,groupNo,adminId,companyId);
    }

    getShiftID(){
        return this.shiftID;
    }
}

module.exports=Shift;