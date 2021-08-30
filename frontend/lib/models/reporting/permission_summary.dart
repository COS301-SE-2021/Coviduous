import 'dart:convert';

PermissionSummary permissionSummaryFromJson(String str) => PermissionSummary.fromJson(json.decode(str));

String permissionSummaryToJson(PermissionSummary data) => json.encode(data.toJson());

class PermissionSummary {
  String permissionSummaryId;
  String companyId;
  String year;
  String month;
  int totalPermissions;
  int permissionsDeniedUsers;
  int permissionsDeniedVisitors;
  int permissionsGrantedUsers;
  int permissionsGrantedVisitors;

  PermissionSummary({
    this.permissionSummaryId = "",
    this.companyId = "",
    this.year = "",
    this.month = "",
    this.totalPermissions = 0,
    this.permissionsDeniedUsers = 0,
    this.permissionsDeniedVisitors = 0,
    this.permissionsGrantedUsers = 0,
    this.permissionsGrantedVisitors = 0,
  });

  factory PermissionSummary.fromJson(Map<String, dynamic> json) => PermissionSummary(
    permissionSummaryId: json["permissionSummaryId"],
    companyId: json["companyId"],
    year: json["year"].toString(),
    month: json["month"].toString().padLeft(2, "0"),
    totalPermissions: (json["totalPermissions"] is String) ? int.parse(json["totalPermissions"]) : json["totalPermissions"],
    permissionsDeniedUsers: (json["numPermissionDeniedUsers"] is String) ? int.parse(json["numPermissionDeniedUsers"]) : json["numPermissionDeniedUsers"],
    permissionsDeniedVisitors: (json["numPermissionDeniedVisitors"] is String) ? int.parse(json["numPermissionDeniedVisitors"]) : json["numPermissionDeniedVisitors"],
    permissionsGrantedUsers: (json["numPermissionGrantedUsers"] is String) ? int.parse(json["numPermissionGrantedUsers"]) : json["numPermissionGrantedUsers"],
    permissionsGrantedVisitors: (json["numPermissionGrantedVisitors"] is String) ? int.parse(json["numPermissionGrantedVisitors"]) : json["numPermissionGrantedVisitors"],
  );

  Map<String, dynamic> toJson() => {
    "permissionSummaryId": permissionSummaryId,
    "companyId": companyId,
    "year": year,
    "month": month,
    "totalPermissions": totalPermissions,
    "numPermissionDeniedUsers": permissionsDeniedUsers,
    "numPermissionDeniedVisitors": permissionsDeniedVisitors,
    "numPermissionGrantedUsers": permissionsGrantedUsers,
    "numPermissionGrantedVisitors": permissionsGrantedVisitors,
  };

  String getPermissionSummaryID() {
    return permissionSummaryId;
  }

  String getCompanyId() {
    return companyId;
  }

  String getYear() {
    return year;
  }

  String getMonth() {
    return month;
  }

  int getTotalPermissions() {
    return totalPermissions;
  }

  int getPermissionsDeniedUsers() {
    return permissionsDeniedUsers;
  }

  int getPermissionsDeniedVisitors() {
    return permissionsDeniedVisitors;
  }

  int getPermissionsGrantedUsers() {
    return permissionsGrantedUsers;
  }

  int getPermissionsGrantedVisitors() {
    return permissionsGrantedVisitors;
  }
}