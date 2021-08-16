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
        permissionRequestId: json["permissionRequestId"],
        userId: json["userId"],
        shiftNumber: json["shiftNumber"],
        timestamp: json["timestamp"],
        reason: json["reason"],
        adminId: json["adminId"],
        companyId: json["companyId"],
      );

  Map<String, dynamic> toJson() => {
        "permissionRequestId": permissionRequestId,
        "userId": userId,
        "shiftNumber": shiftNumber,
        "timestamp": timestamp,
        "reason": reason,
        "adminId": adminId,
        "companyId": companyId,
      };

  String getPermissionRequestId() {
    return permissionRequestId;
  }

  String getUserId() {
    return userId;
  }

  String getShiftNumber() {
    return shiftNumber;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getReason() {
    return reason;
  }

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }
}
