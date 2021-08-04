class GetRoomsRequest {
  String roomNo;

  GetRoomsRequest(String roomNum) {
    this.roomNo = roomNum;
  }

  String getRoomNum() {
    return roomNo;
  }
}
