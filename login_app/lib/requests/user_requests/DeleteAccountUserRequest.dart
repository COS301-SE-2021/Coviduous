class DeleteAccountUserRequest {
  String userID;

  DeleteAccountUserRequest(String userid) {
    this.userID = userid;
  }

  String getUserID() {
    return userID;
  }
}
