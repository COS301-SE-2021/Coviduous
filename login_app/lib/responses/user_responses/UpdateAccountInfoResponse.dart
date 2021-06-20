/*
  File name: update_account_info_response.dart
  Purpose: Holds the response class for updating account information
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the response object for updating account information
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
