/*
  File name: create_notification_response.dart
  Purpose: Holds the response class of creating a notification
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the response object for creating a notification
 */
class CreateNotificationResponse {
  String notificationID;
  String timestamp;
  bool response;
  String responseMessage;

  CreateNotificationResponse(String notificationID, String timestamp,
      bool response, String responseMessage) {
    this.notificationID = notificationID;
    this.timestamp = timestamp;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  String getNotificationID() {
    return this.notificationID;
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
