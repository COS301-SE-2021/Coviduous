/*
  File name: announcement.dart
  Purpose: This class acts as an announcement entity mimicking the announcement table attribute in the database
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
class Announcement {
  String message;
  String type;
  String date;
  String announcementId;
  String adminId;
  String companyId;

  Announcement(announcementID, type, date, message, adminID, companyID) {
    this.type = type;
    this.message = message;
    this.date = date;
    this.announcementId = announcementID;
    this.adminId = adminID;
    this.companyId = companyID;
  }
  String getMessage() {
    return message;
  }

  String getDate() {
    return date;
  }

  String getType() {
    return type;
  }

  String getAnnouncementId() {
    return announcementId;
  }

  String getadminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}
