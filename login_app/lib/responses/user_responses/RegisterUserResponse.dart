class RegisterUserResponse {
  bool response;
  String responseMessage;
  String adminId;

  RegisterUserResponse(String adminId, bool response, String responsemessage) {
    this.response = response;
    this.responseMessage = responsemessage;
    this.adminId = adminId;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }

  String getAdminId() {
    return this.adminId;
  }
}
