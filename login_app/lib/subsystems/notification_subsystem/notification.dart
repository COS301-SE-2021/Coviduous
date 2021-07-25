/**
 * This class acts as an announcement entity mimicking the announcement table attribute in the database
 */
// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

Notification notificationFromJson(String str) =>
    Notification.fromJson(json.decode(str));

String notificationToJson(Notification data) => json.encode(data.toJson());

class Notification {
  String notificationId;
  String userId;
  String userEmail;
  String subject;
  String message;
  String timestamp;
  String adminId;
  String companyId;

  Notification({
    this.notificationId,
    this.userId,
    this.userEmail,
    this.subject,
    this.message,
    this.timestamp,
    this.adminId,
    this.companyId,
  });

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        notificationId: json["notificationID"],
        userId: json["userID"],
        userEmail: json["userEmail"],
        subject: json["subject"],
        message: json["message"],
        timestamp: json["timestamp"],
        adminId: json["adminID"],
        companyId: json["companyID"],
      );

  Map<String, dynamic> toJson() => {
        "notificationID": notificationId,
        "userID": userId,
        "userEmail": userEmail,
        "subject": subject,
        "message": message,
        "timestamp": timestamp,
        "adminID": adminId,
        "companyID": companyId,
      };
}
