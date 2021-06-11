class DeleteAnnouncementRequest {
  String announcementId;

  DeleteAnnouncementRequest(String announcementID) {
    this.announcementId = announcementID;
  }

  String getAnnouncementId() {
    return this.announcementId;
  }
}
