class bookOfficeSpaceRequest {
  //add code for request object
  String floorNum = "";
  String roomNum = "";
  String user = "";

  bookOfficeSpaceRequest(String user, String floorNum, String roomNum) {
    this.floorNum = floorNum;
    this.roomNum = roomNum;
    this.user = user;
  }

  String getFloorNumber() {
    return floorNum;
  }

  String getRoomNumber() {
    return roomNum;
  }

  String getUser() {
    return user;
  }
}
