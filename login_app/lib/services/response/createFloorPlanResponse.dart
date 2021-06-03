class createFloorPlanResponse {
  //add code for response object
  bool successful = false;

  createFloorplanResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
