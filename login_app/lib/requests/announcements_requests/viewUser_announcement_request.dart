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
