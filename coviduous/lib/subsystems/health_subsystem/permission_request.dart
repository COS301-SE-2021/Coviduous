// To parse this JSON data, do
//
//     final permissionRequest = permissionRequestFromJson(jsonString);

import 'dart:convert';

PermissionRequest permissionRequestFromJson(String str) =>
    PermissionRequest.fromJson(json.decode(str));

String permissionRequestToJson(PermissionRequest data) =>
    json.encode(data.toJson());

class PermissionRequest {
  String permissionRequestId;
  String userId;
  String shiftNumber;
  String timestamp;
  String reason;
  String adminId;
  String companyId;

  PermissionRequest({
    this.permissionRequestId,
    this.userId,
    this.shiftNumber,
    this.timestamp,
    this.reason,
    this.adminId,
    this.companyId,
  });

  factory PermissionRequest.fromJson(Map<String, dynamic> json) =>
      PermissionRequest(
        permissionRequestId: json["permissionRequestID"],
        userId: json["userID"],
        shiftNumber: json["shiftNumber"],
        timestamp: json["timestamp"],
        reason: json["reason"],
        adminId: json["adminID"],
        companyId: json["companyID"],
      );

  Map<String, dynamic> toJson() => {
        "permissionRequestID": permissionRequestId,
        "userID": userId,
        "shiftNumber": shiftNumber,
        "timestamp": timestamp,
        "reason": reason,
        "adminID": adminId,
        "companyID": companyId,
      };
}
