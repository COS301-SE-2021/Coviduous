/**
 * This class acts as a group entity mimicking the group table attribute in the database
 */
// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  String groupNumber;
  String groupName;
  List<String> userEmails;
  String shiftNumber;
  String adminId;

  Group({
    this.groupNumber,
    this.groupName,
    this.userEmails,
    this.shiftNumber,
    this.adminId,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupNumber: json["groupNumber"],
        groupName: json["groupName"],
        userEmails: json["userEmails"],
        shiftNumber: json["shiftNumber"],
        adminId: json["adminId"],
      );

  Map<String, dynamic> toJson() => {
        "groupNumber": groupNumber,
        "groupName": groupName,
        "userEmails": userEmails,
        "shiftNumber": shiftNumber,
        "adminId": adminId,
      };

  String getGroupNumber() {
    return groupNumber;
  }

  String getGroupName() {
    return groupName;
  }

  List<String> getUserEmails() {
    return userEmails;
  }

  String getShiftNumber() {
    return shiftNumber;
  }

  String getAdminId() {
    return adminId;
  }
}
