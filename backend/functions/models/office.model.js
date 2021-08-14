class booking {
    constructor(dateTime, floorNum, roomNum, user, deskNum)
    {
        this.dateTime = dateTime;
        this.numFloors = floorNum;
        this.numRooms = roomNum;
        this.user = user;
        this.numDesk = deskNum;

        console.log("created booking class");
    }
}

module.exports = booking;

