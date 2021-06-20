/*
  File name: delete_account_user_response.dart
  Purpose: Holds the response class of deleting a users account by the admin
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for deleting a users account by the admin
 */
class DeleteAccountUserResponse {
  String message;
  bool successful;

  DeleteAccountUserResponse(bool sucess, String message) {
    this.message = message;
    this.successful = sucess;
  }

  String getMessage() {
    return message;
  }

  bool getResponse() {
    return successful;
  }
}
