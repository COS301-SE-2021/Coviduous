class Room {
  String roomNum; //Room identifier
  double
      dimensions; //The dimensions of a room are determined by the square ft of the room which the admin can calculate or fetch from the buildings architectural documentation.
  double
      percentage; //The percentage is determined by the alert level of the country
  int numDesks; //Number of desks inside the room it is also assumed at this stage that desks only have a shape of rectangle or square and all desks inside a room have the same length and width.
  double deskLength; //Length of desk
  double deskWidth; //Width of desk
  double
      capacityOfPeopleForTwelveFtGrid; //Number of people allowed in the room for 12ft distance to be maintained
  double
      capacityOfPeopleForSixFtGrid; //Number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForSixFtCircle; //Number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForEightFtGrid; //Number of people allowed in the room for 8ft distance to be maintained
  double
      capacityOfPeopleForEightFtCircle; //Number of people allowed in the room for 8ft distance to be maintained
  double occupiedDesks;

  Room(String roomNum, double dimensions, double percentage, int numDesks,
      double deskLength, double deskWidth) {
    this.roomNum = roomNum;
    this.dimensions = dimensions;
    this.percentage = percentage;
    this.numDesks = numDesks;
    this.deskLength = deskLength;
    this.deskWidth = deskWidth;
    this.capacityOfPeopleForTwelveFtGrid =
        (((dimensions) - ((deskLength * deskWidth) * numDesks)) / 144);
    this.capacityOfPeopleForSixFtGrid =
        ((((dimensions) - ((deskLength * deskWidth) * numDesks)) *
                (percentage / 100.0)) /
            36);
    this.capacityOfPeopleForSixFtCircle =
        ((((dimensions) - ((deskLength * deskWidth) * numDesks)) *
                (percentage / 100.0)) /
            28);
    this.capacityOfPeopleForEightFtGrid =
        ((((dimensions) - ((deskLength * deskWidth) * numDesks)) *
                (percentage / 100.0)) /
            64);
    this.occupiedDesks = 0;
  }
//display capacity
//displays information about the room..
  void displayCapacity() {
    print(
        "***************************************************************************************");
    print("Displaying Room Information");
    print("Room No.: " + roomNum);
    print("Alert Level Percentage : " + percentage.toString());
    print("Occupied Capacity : " + occupiedDesks.toString());
    print("Space Left : " +
        (this.capacityOfPeopleForSixFtGrid - this.occupiedDesks).toString());
    print("                  ");
  }

  bool bookDesk() {
    if (occupiedDesks < numDesks) {
      occupiedDesks++;
      return true;
    } else {
      print("All tables in this room have been occupied");
      return false;
    }
  }
}
