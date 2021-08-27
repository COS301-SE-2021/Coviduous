import 'dart:convert';

HealthSummary healthSummaryFromJson(String str) => HealthSummary.fromJson(json.decode(str));

String healthSummaryToJson(HealthSummary data) => json.encode(data.toJson());

class HealthSummary {
  String healthSummaryId;
  String companyId;
  String timestamp;
  String year;
  String month;
  int reportedRecoveries;
  int reportedInfections;
  int healthChecksUsers;
  int healthChecksVisitors;

  HealthSummary({
    this.healthSummaryId,
    this.companyId,
    this.timestamp,
    this.year,
    this.month,
    this.reportedRecoveries,
    this.reportedInfections,
    this.healthChecksUsers,
    this.healthChecksVisitors,
  });

  factory HealthSummary.fromJson(Map<String, dynamic> json) => HealthSummary(
    healthSummaryId: json["healthSummaryId"],
    companyId: json["companyId"],
    timestamp: json["timestamp"],
    year: json["year"],
    month: json["month"],
    reportedRecoveries: json["numReportedRecoveries"],
    reportedInfections: json["numReportedInfections"],
    healthChecksUsers: json["numHealthChecksUsers"],
    healthChecksVisitors: json["numHealthChecksVisitors"],
  );

  Map<String, dynamic> toJson() => {
    "healthSummaryId": healthSummaryId,
    "companyId": companyId,
    "timestamp": timestamp,
    "year": year,
    "month": month,
    "numReportedRecoveries": reportedRecoveries,
    "numReportedInfections": reportedInfections,
    "numHealthChecksUsers": healthChecksUsers,
    "numHealthChecksVisitors": healthChecksVisitors,
  };

  String getHealthSummaryID() {
    return healthSummaryId;
  }

  String getCompanyId() {
    return companyId;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getYear() {
    return year;
  }

  String getMonth() {
    return month;
  }

  int getReportedRecoveries() {
    return reportedRecoveries;
  }

  int getReportedInfections() {
    return reportedInfections;
  }

  int getHealthChecksUsers() {
    return healthChecksUsers;
  }

  int getHealthChecksVisitors() {
    return healthChecksVisitors;
  }
}