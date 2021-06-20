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
  String companyId;

  User(String type, String FirstName, String LastName, String Username,
      String Email, String Password, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    int randomInt2 = new Random().nextInt((9999 - 100) + 1) + 10;

    this.userId = "USR-" + randomInt.toString();
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
}
