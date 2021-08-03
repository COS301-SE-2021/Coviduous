/*
  File name: delete_announcement_response.dart
  Purpose: Holds the response class of deleting an announcement
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for deleting an announcement by the admin
 */
class DeleteAnnouncementResponse {
  bool response;
  String responseMessage;

  DeleteAnnouncementResponse(bool response, String responseMessage) {
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
