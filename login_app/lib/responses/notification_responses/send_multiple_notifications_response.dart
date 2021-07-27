/*
  File name: send_multiple_notifications_response.dart
  Purpose: Holds the response class of sending all notifications
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for retrieving shifts by the admin user
 */
class SendMultipleNotificationResponse {
  bool response;
  String responseMessage;

  SendMultipleNotificationResponse(bool response, String responseMessage) {
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
