class BookOfficeSpaceRequest {
  String floorNum = "";
  String roomNum = "";
  String user = "";
//bookofficespaceRequest

  BookOfficeSpaceRequest(String user, String floorNum, String roomNum) {
    this.floorNum = floorNum;
    this.roomNum = roomNum;
    this.user = user;
  }
//getFloorNumber
  //returns number of floors
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
