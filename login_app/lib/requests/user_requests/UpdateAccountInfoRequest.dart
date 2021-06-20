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
