import 'dart:math';

class User {
  String userId;
  String type;
  String first_name;
  String last_name;
  String username;
  String email;
  String password;
  String activation_code;
  String adminId;
  String companyId;

  User(String type, String FirstName, String LastName, String Username,
      String Email, String Password, String adminID, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.userId = "USR-" + randomInt.toString();
    this.type = type;
    this.first_name = FirstName;
    this.last_name = LastName;
    this.email = Email;
    this.password = Password;
    this.activation_code = "ACTIV-" + randomInt.toString();
    this.adminId = adminID;
    this.companyId = companyID;
  }

  //Currently announcements will need the companyId and userId more getters need to be implemented
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
}
