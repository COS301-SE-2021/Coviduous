/**
 * This class holds the request object for viewing an announcement by the user
 */
class ViewUserAnnouncementRequest {
  String userId;
  ViewUserAnnouncementRequest(String Userid) {
    print("Created Request");
    this.userId = Userid;
  }

  String getUserId() {
    return userId;
  }
}
