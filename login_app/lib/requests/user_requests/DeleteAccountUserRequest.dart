/**
 * This class holds the request object for deleting an account assigned to a user by the admin
 */
class DeleteAccountUserRequest {
  String userID;

  DeleteAccountUserRequest(String userid) {
    this.userID = userid;
  }

  String getUserID() {
    return userID;
  }
}
