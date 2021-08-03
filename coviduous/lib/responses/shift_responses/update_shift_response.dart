/*
  File name: update_shift_response.dart
  Purpose: Holds the response class of updating a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for updating a shift by the admin user
 */
class UpdateShiftResponse {
  bool response;
  String responseMessage;

  UpdateShiftResponse(bool response, String responseMessage) {
    this.response = response;
    this.responseMessage = responseMessage;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
