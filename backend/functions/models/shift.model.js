class Shift {
    constructor(shiftID, date, startTime, endTime, description, adminId, companyId)
    {
        this.shiftID = shiftID;
        this.description = description;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.companyId = companyId;
        this.adminId = adminId;

        console.log("Created shift class")
    }

    Shift(shiftID, date, startTime, endTime, description, adminId, companyId) {
        return new Shift(shiftID, date, startTime, endTime, description, adminId, companyId);
    }

    getShiftID() {
        return this.shiftID;
    }
}

module.exports = Shift;