/**
 * This class holds the response object for registering an admin
 */

class RegisterAdminResponse {
  String userID;
  String adminID;
  bool response;
  String resMessage;

  RegisterAdminResponse(
      String userid, String adminid, bool res, String resmess) {
    this.userID = userid;
    this.adminID = adminid;
    this.response = res;
    this.resMessage = resmess;
  }

  String getUserID() {
    return userID;
  }

  String getAdminID() {
    return adminID;
  }

  bool getResponse() {
    return response;
  }

  String getMessage() {
    return resMessage;
  }
}
