class CreateAnnouncementResponse {
  String announcementID;
  String timestamp;
  bool response;
  String responseMessage;

  CreateAnnouncementResponse(String announcementID, String timestamp,
      bool response, String responseMessage) {
    this.announcementID = announcementID;
    this.timestamp = timestamp;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  String getAnnouncementID() {
    return this.announcementID;
  }

  String getTimestamp() {
    return this.timestamp;
  }
}