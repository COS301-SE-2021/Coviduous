/**
 * This class acts as a permission entity mimicking the permission table attribute in the database
 */
// To parse this JSON data, do
//
//     final permission = permissionFromJson(jsonString);

import 'dart:convert';

Permission permissionFromJson(String str) =>
    Permission.fromJson(json.decode(str));

String permissionToJson(Permission data) => json.encode(data.toJson());

class Permission {
  String permissionId;
  String userId;
  String timestamp;
  String officeAccess;
  String grantedBy;

  // constructor
  Permission({
    this.permissionId,
    this.userId,
    this.timestamp,
    this.officeAccess,
    this.grantedBy,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        permissionId: json["permissionID"],
        userId: json["userID"],
        timestamp: json["timestamp"],
        officeAccess: json["officeAccess"],
        grantedBy: json["grantedBy"],
      );

  Map<String, dynamic> toJson() => {
        "permissionID": permissionId,
        "userID": userId,
        "timestamp": timestamp,
        "officeAccess": officeAccess,
        "grantedBy": grantedBy,
      };
}
