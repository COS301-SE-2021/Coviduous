class Desk {
  String deskNum;
  String roomNum;
  double deskDimentions;
  int maxCapacity;
  int currentCapacity;

  Desk(String desknum, String roomnum, double deskdimentions, int maxcapacity,
      int currentcapacity) {
    this.deskNum = desknum;
    this.roomNum = roomnum;
    this.deskDimentions = deskdimentions;
    this.maxCapacity = maxcapacity;
    this.currentCapacity = currentcapacity;
  }

  String getDeskNum() {
    return deskNum;
  }

  String getRoomNum() {
    return roomNum;
  }

  double getDeskDimentions() {
    return deskDimentions;
  }

  int getMaxCapacity() {
    return maxCapacity;
  }

  int getCurrentCapacity() {
    return currentCapacity;
  }
}
