/*
  File name: register_user_request.dart
  Purpose: Holds the request class for registering a user
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the request object for registering a user
 */
class RegisterUserRequest {
  String type;
  String firstName;
  String lastName;
  String username;
  String email;
  String password;
  String companyID;

  RegisterUserRequest(String type, String firstName, String lastName,
      String username, String email, String password, String companyID) {
    this.type = type;
    this.firstName = firstName;
    this.lastName = lastName;
    this.username = username;
    this.email = email;
    this.password = password;
    this.companyID = companyID;
  }

  String getType() {
    return this.type;
  }

  String getFirstName() {
    return this.firstName;
  }

  String getLastName() {
    return this.lastName;
  }

  String getUsername() {
    return this.username;
  }

  String getEmail() {
    return this.email;
  }

  String getPassword() {
    return this.password;
  }

  String getCompanyID() {
    return this.companyID;
  }
}