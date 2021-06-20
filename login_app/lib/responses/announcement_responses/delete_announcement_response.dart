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
