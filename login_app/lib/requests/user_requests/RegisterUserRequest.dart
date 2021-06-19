class RegisterUserRequest {
  String firstname;
  String lastname;
  String username;
  String email;
  String password;
  String activationCode;
  String companyID;

  RegisterUserRequest() {}

  String getFirstname() {
    return firstname;
  }

  String getLastname() {
    return lastname;
  }

  String getUsername() {
    return username;
  }

  String getEmail() {
    return email;
  }

  String getCompanyID() {
    return companyID;
  }
}
