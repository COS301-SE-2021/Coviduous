/*
  File name: create_shift_response.dart
  Purpose: Holds the response class of creating a shift
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the response object for creating a shift
 */
class CreateShiftResponse {
  String shiftID;
  String timestamp;
  bool response;
  String responseMessage;

  CreateShiftResponse(
      String shiftID, String timestamp, bool response, String responseMessage) {
    this.shiftID = shiftID;
    this.timestamp = timestamp;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  String getShiftID() {
    return this.shiftID;
  }

  String getTimestamp() {
    return this.timestamp;
  }

  bool getResponse() {
    return this.response;
  }

  String getResponseMessage() {
    return this.responseMessage;
  }
}
