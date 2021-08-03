/*
  File name: delete_shift_response.dart
  Purpose: Holds the response class of deleting a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for deleting a shift by the admin user
 */
class DeleteShiftResponse {
  bool response;
  String responseMessage;

  DeleteShiftResponse(bool response, String responseMessage) {
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
