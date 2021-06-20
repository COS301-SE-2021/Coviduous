/*
  File name: create_announcement_request.dart
  Purpose: Holds the request class of creating an announcement
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * Purpose: This class holds the request object of creating an announcement
 */
class CreateAnnouncementRequest {
  String type;
  String message;
  String adminID;
  String companyID;

  CreateAnnouncementRequest(
      String type, String message, String adminID, String companyID) {
    this.type = type;
    this.message = message;
    this.adminID = adminID;
    this.companyID = companyID;
  }

  String getType() {
    return this.type;
  }

  String getMessage() {
    return this.message;
  }

  String getAdminID() {
    return this.adminID;
  }

  String getCompanyID() {
    return this.companyID;
  }
}
