class BookOfficeSpaceResponse {
  bool successful = false;

  BookOfficeSpaceResponse(bool success) {
    this.successful = success;
  }

  bool getResponse() {
    return successful;
  }
}
