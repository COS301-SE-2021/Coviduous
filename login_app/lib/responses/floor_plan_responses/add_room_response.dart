/**
 * This class holds the response object for creating a floor plan
 */

class AddRoomResponse {
  bool successful = false;
  String floorPlanId;

  AddRoomResponse(bool success, String floorplan) {
    this.floorPlanId = floorplan;
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
