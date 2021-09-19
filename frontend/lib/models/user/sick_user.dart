import 'dart:convert';

SickUser sickUserFromJson(String str) => SickUser.fromJson(json.decode(str));

String sickUserToJson(SickUser data) => json.encode(data.toJson());

class SickUser {
  String userId;
  String email;
  String companyId;
  String timeOfDiagnosis;

  SickUser({
    this.userId,
    this.email,
    this.companyId,
    this.timeOfDiagnosis,
  });

  factory SickUser.fromJson(Map<String, dynamic> json) => SickUser(
    userId: json["userId"],
    email: json["userEmail"],
    companyId: json["companyId"],
    timeOfDiagnosis: json["timeOfDiagnosis"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userEmail": email,
    "companyId": companyId,
    "timeOfDiagnosis": timeOfDiagnosis,
  };

  String getUserId() {
    return userId;
  }

  String getEmail() {
    return email;
  }

  String getCompanyId() {
    return companyId;
  }

  String getTimeOfDiagnosis() {
    return timeOfDiagnosis;
  }

  @override
  String toString() {
    return "User ID: " + userId + "\nEmail: " + email + "\nCompany ID: " + companyId + "\nTime of diagnosis: " + timeOfDiagnosis;
  }
}