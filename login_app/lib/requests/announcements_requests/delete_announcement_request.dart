/*
  File name: delete_announcement_request.dart
  Purpose: Holds the request class of deleting an announcement
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of deleting an announcement by an admin user
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
