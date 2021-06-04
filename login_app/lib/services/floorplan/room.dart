class room {
  //add all the room attributes
  String roomNum; //Room identifier
  double
      dimentions; // The dimentions of a room are deterimend by the square ft of the room which the admin can calculate or fetch from the buildings architectual documentation.
  double
      percentage; //The percentage is detetermined by the alert level of the country
  int numDesks; // number of desks inside the room it is also assumed at this stage that desks only have a shape of rectange or square and all desks inside a room have the same length and width.
  double deskLength; //length of desk
  double deskWidth; //width of desk
  double
      capacityOfPeopleForTwelveFtGrid; //number of people allowed in the room for 12ft distance to be maintained
  double
      capacityOfPeopleForSixFtGrid; //number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForSixFtCircle; //number of people allowed in the room for 6ft distance to be maintained
  double
      capacityOfPeopleForEightFtGrid; //number of people allowed in the room for 8ft distance to be maintained
  double
      capacityOfPeopleForEightFtCircle; //number of people allowed in the room for 8ft distance to be maintained
  double occupiedDesks;
//constructor room class
//receives room number, dimensions, percentage, number of desks, desk length, desk width
  room(String roomNum, double dimentions, double percentage, int numDesks,
      double deskLength, double deskWidth) {
    this.roomNum = roomNum;
    this.dimentions = dimentions;
    this.percentage = percentage;
    this.numDesks = numDesks;
    this.deskLength = deskLength;
    this.deskWidth = deskWidth;
    this.capacityOfPeopleForTwelveFtGrid =
        (((dimentions) - ((deskLength * deskWidth) * numDesks)) / 144);
    this.capacityOfPeopleForSixFtGrid =
        ((((dimentions) - ((deskLength * deskWidth) * numDesks)) *
                (percentage / 100.0)) /
            36);
    this.capacityOfPeopleForSixFtCircle =
        ((((dimentions) - ((deskLength * deskWidth) * numDesks)) *
                (percentage / 100.0)) /
            28);
    this.capacityOfPeopleForEightFtGrid =
        ((((dimentions) - ((deskLength * deskWidth) * numDesks)) *
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
//desk booking
//returns boolean
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
