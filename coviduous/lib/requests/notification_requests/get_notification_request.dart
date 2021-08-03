/*
  File name: get_notification_request.dart
  Purpose: Holds the request class of retrieving all notifications based on userEmail
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of retrieving notifications by an admin user
 */
class GetNotificationRequest {
  String userEmail;

  GetNotificationRequest(String userEmail) {
    this.userEmail = userEmail;
  }

  String getUserEmail() {
    return this.userEmail;
  }
}
