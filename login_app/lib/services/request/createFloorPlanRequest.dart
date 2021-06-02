class createFloorPlanRequest {
  String admin = "";
  int floorNumber = 0;
  int totalRooms = 0;

  createFloorPlanRequest(String admin, int floorNumber, int totalRooms) {
    this.admin = admin;
    this.floorNumber = floorNumber;
    this.totalRooms = totalRooms;
  }

  String getAdmin() {
    return admin;
  }

  int getFloorNumber() {
    return floorNumber;
  }

  int getTotalRooms() {
    return totalRooms;
  }
}
