class createFloorPlanRequest {
  //add code for request object
  String admin = "";
  String floorNumber = "";
  int totalRooms = 0;

  createFloorPlanRequest(String admin, String floorNumber, int totalRooms) {
    this.admin = admin;
    this.floorNumber = floorNumber;
    this.totalRooms = totalRooms;
  }

  String getAdmin() {
    return admin;
  }

  String getFloorNumber() {
    return floorNumber;
  }

  int getTotalRooms() {
    return totalRooms;
  }
}
