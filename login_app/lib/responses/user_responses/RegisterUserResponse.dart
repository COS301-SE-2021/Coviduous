class RegisterUserResponse {
  bool response;
  String responseMessage;
  String id;

  RegisterUserResponse(String id, bool response, String responsemessage) {
    this.response = response;
    this.responseMessage = responsemessage;
    this.id = id;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }

  String getId() {
    return this.id;
  }
}
