/**
 * This class holds the request object for editing a room
 */

class EditRoomRequest {
  String floorNum;
  String roomNum;
  String sdroomNum;
  double dimensions;
  double percentage;
  int numDesks;
  double deskDimentions;
  int deskMaxCapaciy;

  EditRoomRequest(
      String floornum,
      String roomnum,
      String sdroomnum,
      double Dimentions,
      double Percentage,
      int numdesks,
      double deskdimentions,
      int DeskMaxCapcity) {
    this.floorNum = floornum;
    this.roomNum = roomnum;
    this.sdroomNum = sdroomnum;
    this.dimensions = Dimentions;
    this.percentage = Percentage;
    this.numDesks = numdesks;
    this.deskDimentions = deskdimentions;
    this.deskMaxCapaciy = DeskMaxCapcity;
  }

  String getFloorNumber() {
    return floorNum;
  }

  String getRoomNumber() {
    return roomNum;
  }

  String getSystemDefinedRoomNumber() {
    return sdroomNum;
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

  int getDeskMaxCapaciy() {
    return deskMaxCapaciy;
  }
}
