/**
 * This class holds the request object object of deleting an announcement by an admin user
 */
class DeleteAnnouncementRequest {
  String announcementId;

  DeleteAnnouncementRequest(String announcementID) {
    this.announcementId = announcementID;
  }

  String getAnnouncementId() {
    return this.announcementId;
  }
}
