/*
  File name: delete_account_user_request.dart
  Purpose: Holds the request class of deleting a user
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object for deleting an account assigned to a user by the admin
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
