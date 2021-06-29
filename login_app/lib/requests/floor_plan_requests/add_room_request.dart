/**
 * This class holds the request object for creating a floor plan
 */

class AddRoomRequest {
  String floorNum;
  String roomNum;
  double dimensions;
  double percentage;
  int numDesks;
  double deskDimentions;

  AddRoomRequest(String floornum, String roomnum, double Dimentions,
      double Percentage, int numdesks, double deskdimentions) {
    this.floorNum = floornum;
    this.roomNum = roomnum;
    this.dimensions = Dimentions;
    this.percentage = Percentage;
    this.numDesks = numdesks;
    this.deskDimentions = deskdimentions;
  }

  String getFloorNumber() {
    return floorNum;
  }

  String getRoomNumber() {
    return roomNum;
  }

  double getDimentions() {
    return dimensions;
  }

  double getDeskDimentions() {
    return deskDimentions;
  }

  int getNumDesks() {
    return numDesks;
  }

  double getPercentage() {
    return percentage;
  }
}
