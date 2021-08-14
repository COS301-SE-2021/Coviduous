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
  String groupId;
  String groupName;
  String userEmail;
  String shiftNumber;
  String adminId;

  Group({
    this.groupId,
    this.groupName,
    this.userEmail,
    this.shiftNumber,
    this.adminId,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json["groupID"],
        groupName: json["groupName"],
        userEmail: json["userEmail"],
        shiftNumber: json["shiftNumber"],
        adminId: json["adminID"],
      );

  Map<String, dynamic> toJson() => {
        "groupID": groupId,
        "groupName": groupName,
        "userEmail": userEmail,
        "shiftNumber": shiftNumber,
        "adminID": adminId,
      };
}
