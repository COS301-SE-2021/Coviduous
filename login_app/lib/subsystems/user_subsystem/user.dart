import 'dart:math';

import 'package:flutter/material.dart';

class User {
  String userId;
  String adminId;
  String type;
  String first_name;
  String last_name;
  String username;
  String email;
  String password;
  String activation_code;
  String companyId;

  User(String type, String FirstName, String LastName, String Username,
      String Email, String Password, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    int randomInt2 = new Random().nextInt((9999 - 100) + 1) + 10;

    if (type == "Admin" || type == "admin" || type == "ADMIN") {
      this.adminId = "USRAD-" + randomInt.toString();
      this.userId = "";
    } else {
      this.userId = "USR-" + randomInt.toString();
      this.adminId = "";
    }
    this.type = type;
    this.first_name = FirstName;
    this.last_name = LastName;
    this.email = Email;
    this.password = Password;
    this.activation_code = "ACTIV-" + randomInt2.toString();
    this.companyId = companyID;
  }

  String getFirstName() {
    return first_name;
  }

  String getLastName() {
    return last_name;
  }

  String getCompanyId() {
    return companyId;
  }

  String getUserId() {
    return userId;
  }

  String getAdminId() {
    return adminId;
  }

  String getId() {
    if (adminId == "") {
      return userId;
    } else if (userId == "") {
      return adminId;
    } else {
      return null;
    }
  }

  String getEmail() {
    return email;
  }
}
