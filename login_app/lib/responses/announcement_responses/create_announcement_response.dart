/**
 * This class holds the response object for creating an announcement
 */
class CreateAnnouncementResponse {
  String announcementID;
  String timestamp;
  bool response;
  String responseMessage;
  int numAnnouncements;

  CreateAnnouncementResponse(String announcementID, String timestamp,
      bool response, String responseMessage) {
    this.announcementID = announcementID;
    this.timestamp = timestamp;
    this.response = response;
    this.responseMessage = responseMessage;
  }

  void setNumAnnouncements(int num) {
    this.numAnnouncements = num;
  }

  int getNumAnnouncements() {
    return this.numAnnouncements;
  }

  String getAnnouncementID() {
    return this.announcementID;
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
