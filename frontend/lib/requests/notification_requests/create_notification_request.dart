/*
  File name: create_notification_request.dart
  Purpose: Holds the request class of creating a notification
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of creating a notification
 */
class CreateNotificationRequest {
  String userId;
  String userEmail;
  String subject;
  String message;
  String adminId;
  String companyId;

  CreateNotificationRequest(
    String userId,
    String userEmail,
    String subject,
    String message,
    String adminId,
    String companyId,
  ) {
    this.userId = userId;
    this.userEmail = userEmail;
    this.subject = subject;
    this.message = message;
    this.adminId = adminId;
    this.companyId = companyId;
  }

  // String getType() {
  //   return this.type;
  // }

  // String getMessage() {
  //   return this.message;
  // }

  // String getAdminID() {
  //   return this.adminID;
  // }

  // String getCompanyID() {
  //   return this.companyID;
  // }
}
