class createFloorPlanRequest {
  //add code for request object
  String admin = "";
  String floorNumber = "";
  int totalRooms = 0;

//create floor plan request
//initialize admin
//initialize number of floor
//initialize total number of rooms
  createFloorPlanRequest(String admin, String floorNumber, int totalRooms) {
    this.admin = admin;
    this.floorNumber = floorNumber;
    this.totalRooms = totalRooms;
  }
// get admin function
//return admin
  String getAdmin() {
    return admin;
  }
// get number of floor
//return floor number
  String getFloorNumber() {
    return floorNumber;
  }

  int getTotalRooms() {
    return totalRooms;
  }
}
