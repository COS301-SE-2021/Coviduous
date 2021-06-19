class RegisterUserResponse {
  String userID;
  String adminID;
  String activation_code;
  bool response;
  String responseMessage;

  RegisterUserResponse(String userID, String adminID, String code,
      bool response, String responseMessage) {
    this.userID = userID;
    this.adminID = adminID;
    this.response = response;
    this.activation_code = code;
    this.responseMessage = responseMessage;
  }

  String getUserID() {
    return this.userID;
  }

  String getAdminID() {
    return this.adminID;
  }

  String getActivationCode() {
    return this.activation_code;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}