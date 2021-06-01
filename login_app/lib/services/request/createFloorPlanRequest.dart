class createFloorPlanRequest {
  String admin;
  int floorNumber;
  int totalRooms;

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
