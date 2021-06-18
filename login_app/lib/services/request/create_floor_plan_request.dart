class CreateFloorPlanRequest {
  String admin = "";
  String floorNumber = "";
  int totalRooms = 0;

  CreateFloorPlanRequest(String admin, String floorNumber, int totalRooms) {
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