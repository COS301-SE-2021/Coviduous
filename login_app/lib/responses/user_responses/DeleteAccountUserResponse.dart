class DeleteAccountUserResponse {
  String message;
  bool successful;

  DeleteAccountUserResponse(bool sucess, String message) {
    this.message = message;
    this.successful = sucess;
  }

  String getMessage() {
    return message;
  }

  bool getResponse() {
    return successful;
  }
}
