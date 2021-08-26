import 'dart:convert';

RecoveredUser recoveredUserFromJson(String str) => RecoveredUser.fromJson(json.decode(str));

String recoveredUserToJson(RecoveredUser data) => json.encode(data.toJson());

class RecoveredUser {
  String userId;
  String email;
  String companyId;
  String recoveredTime;

  RecoveredUser({
    this.userId,
    this.email,
    this.companyId,
    this.recoveredTime,
  });

  factory RecoveredUser.fromJson(Map<String, dynamic> json) => RecoveredUser(
    userId: json["userId"],
    email: json["userEmail"],
    companyId: json["companyId"],
    recoveredTime: json["recoveredTime"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userEmail": email,
    "companyId": companyId,
    "recoveredTime": recoveredTime,
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

  String getRecoveredTime() {
    return recoveredTime;
  }

  @override
  String toString() {
    return "User ID: " + userId + "\nEmail: " + email + "\nCompany ID: " + companyId + "\nRecovered time: " + recoveredTime;
  }
}