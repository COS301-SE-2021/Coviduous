class Booking {
    constructor(bookingNumber, deskNumber, floorPlanNumber, floorNumber, roomNumber, timestamp, userId, companyId) {
        this.bookingNumber = bookingNumber;
        this.deskNumber = deskNumber;
        this.floorPlanNumber = floorPlanNumber;
        this.floorNumber = floorNumber;
        this.roomNumber = roomNumber;
        this.timestamp = timestamp;
        this.userId = userId;
        this.companyId = companyId;

        console.log("Created booking class");
    }
}

module.exports = Booking;

