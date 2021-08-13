class TempNotification {
  String _userId;
  String _userEmail;

  TempNotification(String id, String email){
    _userId = id;
    _userEmail = email;
  }

  String getUserEmail() {
    return _userEmail;
  }

  setUserEmail(String email) {
    _userEmail = email;
  }

  String getUserId() {
    return _userId;
  }

  setUserId(String id) {
    _userId = id;
  }
}