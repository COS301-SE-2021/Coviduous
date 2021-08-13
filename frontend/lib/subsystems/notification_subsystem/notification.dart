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
        notificationId: json["notificationId"],
        userId: json["userId"],
        userEmail: json["userEmail"],
        subject: json["subject"],
        message: json["message"],
        timestamp: json["timestamp"],
        adminId: json["adminId"],
        companyId: json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userId": userId,
        "userEmail": userEmail,
        "subject": subject,
        "message": message,
        "timestamp": timestamp,
        "adminId": adminId,
        "companyId": companyId,
      };
}
