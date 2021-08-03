class DeleteRoomResponse {
  bool successful = false;

  DeleteRoomResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
