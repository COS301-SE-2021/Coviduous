class CreateFloorPlanRequest {
  String admin = "";
  String floorNumber = "";
  int totalRooms = 0;

  CreateFloorPlanRequest(String admin, String floorNumber, int totalRooms) {
    this.admin = admin;
    this.floorNumber = floorNumber;
    this.totalRooms = totalRooms;
  }
// get admin function
//return admin
  String getAdmin() {
    return admin;
  }

  String getFloorNumber() {
    return floorNumber;
  }
//get total number of rooms
  // return total rooms
  int getTotalRooms() {
    return totalRooms;
  }
}
