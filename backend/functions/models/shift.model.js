class Shift {
    constructor(shiftID, date, startTime, endTime, description, adminId,
                companyId, floorPlanNumber, floorNumber, roomNumber) {
        this.shiftID = shiftID;
        this.description = description;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.companyId = companyId;
        this.adminId = adminId;
        this.floorPlanNumber = floorPlanNumber;
        this.floorNumber = floorNumber;
        this.roomNumber = roomNumber;

        console.log("Created shift class")
    }

    Shift(shiftID, date, startTime, endTime, description, adminId,
          companyId, floorPlanNumber, floorNumber, roomNumber) {
        return new Shift(shiftID, date, startTime, endTime, description,
            adminId, companyId, floorPlanNumber, floorNumber, roomNumber);
    }

    getShiftID() {
        return this.shiftID;
    }
}

module.exports = Shift;