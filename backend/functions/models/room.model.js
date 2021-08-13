
class Room {
    constructor(numOfRoomsInFloor, roomNum, floorNum, dimensions, deskDimentions, numDesks, percentage)
    {
        this.currentNumberRoomInFloor = numOfRoomsInFloor;
        this.floorNumber = floorNum;
        this.roomNumber = roomNum;
        this.roomArea = dimensions; //The dimensions of a room are determined by the square ft of the room which the admin can calculate or fetch from the buildings architectural documentation.
        this.capacityPercentage = percentage;
        this.numberDesks = numDesks;
        this.occupiedDesks=0;
        this.currentCapacity=0;
        this.deskArea=deskDimentions; // dimentions of a desk
        //this.capacityOfPeopleForTwelveFtGrid =(((roomArea) - ((deskArea) * numDesks)) / 144);
        this.capacityOfPeopleForSixFtGrid =((((dimensions) - ((deskDimentions) * numDesks)) *(percentage / 100.0)) /36);
        this.capacityOfPeopleForSixFtCircle =((((dimensions) - ((deskDimentions) * numDesks)) *(percentage / 100.0)) /28);
        //this.capacityOfPeopleForEightFtGrid = ((((roomArea) - (deskArea * numDesks)) * (percentage / 100.0)) /64);

        console.log("created room class");
    }

}

module.exports = Room;