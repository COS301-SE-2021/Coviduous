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
    this.permissionSummaryId,
    this.companyId,
    this.year,
    this.month,
    this.totalPermissions,
    this.permissionsDeniedUsers,
    this.permissionsDeniedVisitors,
    this.permissionsGrantedUsers,
    this.permissionsGrantedVisitors,
  });

  factory PermissionSummary.fromJson(Map<String, dynamic> json) => PermissionSummary(
    permissionSummaryId: json["permissionSummaryId"],
    companyId: json["companyId"],
    year: json["year"],
    month: json["month"],
    totalPermissions: json["totalPermissions"],
    permissionsDeniedUsers: json["numPermissionDeniedUsers"],
    permissionsDeniedVisitors: json["numPermissionDeniedVisitors"],
    permissionsGrantedUsers: json["numPermissionGrantedUsers"],
    permissionsGrantedVisitors: json["numPermissionGrantedVisitors"],
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