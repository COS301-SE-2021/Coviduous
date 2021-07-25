// class Group {
//   String email;
//   String groupName;

//   Group(String email, String groupName) {
//     this.email = email;
//     this.groupName = groupName;
//   }

//   String getEmail() {
//     return email;
//   }

//   String getGroupName() {
//     return groupName;
//   }
// }

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
  String floorNumber;
  String roomNumber;
  String adminId;

  Group({
    this.groupId,
    this.groupName,
    this.userEmail,
    this.shiftNumber,
    this.floorNumber,
    this.roomNumber,
    this.adminId,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupId: json["groupID"],
        groupName: json["groupName"],
        userEmail: json["userEmail"],
        shiftNumber: json["shiftNumber"],
        floorNumber: json["floorNumber"],
        roomNumber: json["roomNumber"],
        adminId: json["adminID"],
      );

  Map<String, dynamic> toJson() => {
        "groupID": groupId,
        "groupName": groupName,
        "userEmail": userEmail,
        "shiftNumber": shiftNumber,
        "floorNumber": floorNumber,
        "roomNumber": roomNumber,
        "adminID": adminId,
      };
}
