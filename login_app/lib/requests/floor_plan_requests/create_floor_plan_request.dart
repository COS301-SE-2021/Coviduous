/**
 * This class holds the request object for creating a floor plan
 */

class CreateFloorPlanRequest {
  String admin;
  int numFloors;
  int totalRooms = 0;
  String companyid;

  CreateFloorPlanRequest(
      String admin, String companyId, int numfloors, int numRooms) {
    this.admin = admin;
    this.numFloors = numfloors;
    this.totalRooms = numRooms;
    this.companyid = companyId;
  }
// get admin function
//return admin
  String getAdmin() {
    return admin;
  }

  int getNumFloors() {
    return numFloors;
  }

//get total number of rooms
  // return total rooms
  int getTotalRooms() {
    return totalRooms;
  }

  String getCompanyId() {
    return companyid;
  }
}
