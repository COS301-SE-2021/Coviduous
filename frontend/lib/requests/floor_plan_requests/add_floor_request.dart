class AddFloorRequest {
  String admin;
  String floorNum;
  String floorPlanId;

  AddFloorRequest(String floorplan, String Admin, String floornum) {
    this.floorPlanId = floorplan;
    this.admin = Admin;
    this.floorNum = floornum;
  }

  String getAdmin() {
    return admin;
  }

  String getFloorNum() {
    return floorNum;
  }

  String getFloorPlanNumber() {
    return floorPlanId;
  }
}
