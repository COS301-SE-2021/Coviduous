/**
 * This class holds the request object  of viewing an announcement by the admin
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
