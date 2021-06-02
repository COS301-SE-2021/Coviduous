class bookOfficeSpaceResponse {
  //add code for response object
  DateTime dateTime;
  String floorNum = "";
  String roomNum = "";
  int deskNum = 0;

  bookOfficeSpaceResponse(String floorNum, String roomNum, int deskNum) {
    this.dateTime = DateTime.now();
    this.floorNum = floorNum;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }

  DateTime getDateTime() {
    return dateTime;
  }

  String getFloorNumber() {
    return floorNum;
  }

  String getRoomNumber() {
    return roomNum;
  }

  int getDeskNumber() {
    return deskNum;
  }
}
