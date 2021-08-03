class AddFloorResponse {
  bool successful = false;
  String floorPlanId;

  AddFloorResponse(bool success, String floorplan) {
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
