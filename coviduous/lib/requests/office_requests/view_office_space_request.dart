/**
 * This class holds the request object for viewing an office space that was assigned to a user
 */
class ViewOfficeSpaceRequest {
  String user;

  ViewOfficeSpaceRequest(String user) {
    this.user = user;
  }

  String getUser() {
    return user;
  }
}
