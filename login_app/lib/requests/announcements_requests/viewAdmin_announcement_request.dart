class ViewAdminAnnouncementRequest {
  String announcement_id;

  ViewAdminAnnouncementRequest(String announcementID) {
    this.announcement_id = announcementID;
  }

  String getAnnouncement_id() {
    return announcement_id;
  }
}
