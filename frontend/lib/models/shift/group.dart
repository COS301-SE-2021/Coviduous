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
  List userEmails;
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
        groupNumber: json["groupId"],
        groupName: json["groupName"],
        userEmails: json["userEmails"],
        shiftNumber: json["shiftNumber"],
        adminId: json["adminId"],
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupNumber,
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

  List getUserEmails() {
    return userEmails;
  }

  String getShiftNumber() {
    return shiftNumber;
  }

  String getAdminId() {
    return adminId;
  }
}
