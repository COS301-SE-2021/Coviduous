class AddFloorRequest {
  String admin;
  String floorNum;

  AddFloorRequest(String Admin, String floornum) {
    this.admin = Admin;
    this.floorNum = floornum;
  }

  String getAdmin() {
    return admin;
  }

  String getFloorNum() {
    return floorNum;
  }
}
