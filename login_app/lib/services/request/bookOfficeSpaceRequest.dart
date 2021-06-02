class bookOfficeSpaceRequest {
  //add code for request object
  int floorNum = 0;
  int roomNum = 0;
  int deskNum = 0;

  bookOfficeSpaceRequest(int floorNum, int roomNum, int deskNum) {
    this.floorNum = floorNum;
    this.roomNum = roomNum;
    this.deskNum = deskNum;
  }

  int getFloorNumber() {
    return floorNum;
  }

  int getRoomNumber() {
    return roomNum;
  }

  int getDeskNumber() {
    return deskNum;
  }
}
