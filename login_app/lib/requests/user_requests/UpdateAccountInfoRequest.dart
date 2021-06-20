/*
  File name: update_account_info_request.dart
  Purpose: Holds the request class of updating account info of a user
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */

/**
 * This class holds the request object for updating account info of a user
 */

class UpdateAccountInfoRequest {
  String firstname;
  String lastname;
  String email;

  UpdateAccountInfoRequest(String first, String last, String email) {
    this.firstname = first;
    this.lastname = last;
    this.email = email;
  }

  String getFirstname() {
    return firstname;
  }

  String getLastname() {
    return lastname;
  }

  String getEmail() {
    return email;
  }
}
