/**
 * This class holds the response object for editing a room
 */

class EditRoomResponse {
  bool successful = false;

  EditRoomResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
