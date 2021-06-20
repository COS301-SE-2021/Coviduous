/*
  File name: viewAdmin_announcement_request.dart
  Purpose: Holds the request class of viewing an announcement
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of viewing an announcement by the admin
 */
class ViewAdminAnnouncementRequest {
  String adminId;

  ViewAdminAnnouncementRequest(String AdminId) {
    this.adminId = AdminId;
  }

  String getAdminId() {
    return adminId;
  }
}
