class RegisterUserResponse {
  String userID;
  String adminID;
  bool response;
  String responseMessage;

  RegisterUserResponse(
      String userID, String adminID, bool response, String responseMessage) {
    this.userID = userID;
    this.adminID = adminID;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  String getUserID() {
    return this.userID;
  }

  String getAdminID() {
    return this.adminID;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
