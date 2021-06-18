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
//get number of rooms
// return number of rooms
  String getRoomNumber() {
    return roomNum;
  }
//get name of user
// return user
  String getUser() {
    return user;
  }
}
