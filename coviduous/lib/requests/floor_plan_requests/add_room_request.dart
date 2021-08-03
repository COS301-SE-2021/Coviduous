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
  int deskMaxCapaciy;
  String floorPlanId;

  AddRoomRequest(
      String floorplan,
      String floornum,
      String roomnum,
      double Dimentions,
      double Percentage,
      int numdesks,
      double deskdimentions,
      int DeskMaxCapcity) {
    this.floorPlanId = floorplan;
    this.floorNum = floornum;
    this.roomNum = roomnum;
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

  String getFloorPlanNumber() {
    return floorPlanId;
  }
}
