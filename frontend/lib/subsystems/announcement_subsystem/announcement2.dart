/**
 * This class acts as an announcement entity mimicking the announcement table attribute in the database
 */
// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

import 'dart:convert';

Announcement announcementFromJson(String str) =>
    Announcement.fromJson(json.decode(str));

String announcementToJson(Announcement data) => json.encode(data.toJson());

// Announcement a = new Announcement(announcementId: 'i', type: 'i', message: 'i', ...); // object creation
// String str = announcementToJson(a);

// str = '{announcementId: 'something'}'; //json string
// Announcement a = announcementFromJson(str);
// print(a.announcementId); // or create getAnnouncementId() in constructor

// To parse this JSON data, do
//
//     final announcement = announcementFromJson(jsonString);

//import 'dart:convert';

// create any json mapping class using https://app.quicktype.io/
class Announcement {
  String announcementId;
  String type;
  String message;
  String timestamp;
  String adminId;
  String companyId;

  Announcement({
    this.announcementId,
    this.type,
    this.message,
    this.timestamp,
    this.adminId,
    this.companyId,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        announcementId: json["announcementId"],
        type: json["type"],
        message: json["message"],
        timestamp: json["timestamp"],
        adminId: json["adminId"],
        companyId: json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "announcementId": announcementId,
        "type": type,
        "message": message,
        "timestamp": timestamp,
        "adminId": adminId,
        "companyId": companyId,
      };

  String getAnnouncementId() {
    return announcementId;
  }

  String getType() {
    return type;
  }

  String getMessage() {
    return message;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}
