/**
 * This class holds the response object for creating a floor plan
 */

class CreateFloorPlanResponse {
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
