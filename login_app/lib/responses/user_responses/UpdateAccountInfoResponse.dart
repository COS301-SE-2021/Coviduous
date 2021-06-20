/**
 * This class holds the response object for upadting account information
 */
class UpdateAccountInfoResponse {
  String Message;

  UpdateAccountInfoResponse(String message) {
    Message = message;
  }

  String getMessage() {
    return Message;
  }
}
