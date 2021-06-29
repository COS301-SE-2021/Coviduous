/**
 * This class holds the response object for creating a floor plan
 */

class AddRoomResponse {
  bool successful = false;

  AddRoomResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
