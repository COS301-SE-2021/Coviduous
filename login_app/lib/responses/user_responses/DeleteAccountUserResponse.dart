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
