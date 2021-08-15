/**
 * This class acts as a user entity mimicking the user table attribute in the database
 */

import 'dart:convert';

User announcementFromJson(String str) => User.fromJson(json.decode(str));

String announcementToJson(User data) => json.encode(data.toJson());

class User {
  String userId;
  String type;
  String firstName;
  String lastName;
  String email;
  String userName;
  String companyId;
  String companyName;
  String companyAddress;

  User({
    this.userId,
    this.type,
    this.firstName,
    this.lastName,
    this.email,
    this.userName,
    this.companyId,
    this.companyName = "N/A",
    this.companyAddress = "N/A",
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    type: json["userType"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    email: json["email"],
    userName: json["userName"],
    companyId: json["companyId"],
    companyName: json["companyName"],
    companyAddress: json["companyAddress"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "type": type,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "userName": userName,
    "companyId": companyId,
    "companyName": companyName,
    "companyAddress": companyAddress,
  };

  String getType() {
    return type;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  String getUserId() {
    return userId;
  }

  String getEmail() {
    return email;
  }

  String getUserName() {
    return userName;
  }

  String getCompanyId() {
    return companyId;
  }

  String getCompanyName() {
    return companyName;
  }

  String getCompanyAddress() {
    return companyAddress;
  }
}
