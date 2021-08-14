class Shift {
    constructor(shiftID, date, startTime, endTime, description, groupNo, adminId, companyId)
    {
        this.shiftID = shiftID;
        this.description = description;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.groupNo = groupNo;
        this.companyId = companyId;
        this.adminId = adminId;
    }

    Shift(shiftID, date, startTime, endTime, description,groupNo,adminId,companyId) {
        return new Shift(shiftID, date, startTime, endTime, description, groupNo, adminId, companyId);
    }

    getShiftID(){
        return this.shiftID;
    }
}

module.exports=Shift;