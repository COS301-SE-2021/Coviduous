class AddFloorResponse {
  bool successful = false;

  AddFloorResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }

  void setResponse(bool success) {
    this.successful = success;
  }
}
