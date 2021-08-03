/*
  File name: register_user_response.dart
  Purpose: Holds the response class of registering a user
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for registering a user
 */

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
