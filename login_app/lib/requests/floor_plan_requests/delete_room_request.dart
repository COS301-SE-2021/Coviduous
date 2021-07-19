class DeleteRoomRequest {
  String floorNum;
  String roomNum;

  DeleteRoomRequest(String floornum, String roomnum) {
    this.floorNum = floornum;
    this.roomNum = roomnum;
  }

  String getFloorNum() {
    return floorNum;
  }

  String getRoomNum() {
    return roomNum;
  }
}
