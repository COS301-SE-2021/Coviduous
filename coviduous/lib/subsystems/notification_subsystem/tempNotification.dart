import 'dart:math';

class TempNotification {
  String notificationId;
  String userId;
  String userEmail;
  String subject;
  String message;
  String timestamp;
  String adminId;
  String companyId;

  TempNotification(String userid, String useremail, String notifSubject,
      String notifMessage, String adminid, String companyid) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.notificationId = "NTFN-" + randomInt.toString();
    this.timestamp = DateTime.now().toString();
    this.userId = userid;
    this.userEmail = useremail;
    this.subject = notifSubject;
    this.message = notifMessage;
    this.adminId = adminid;
    this.companyId = companyid;
  }

  String getNotificationId() {
    return notificationId;
  }

  String getUserEmail() {
    return userEmail;
  }

  String getUserId() {
    return userId;
  }

  String getMessage() {
    return message;
    ;
  }

  String getTimestamp() {
    return timestamp;
  }

  String getAdminId() {
    return adminId;
  }

  String getCompanyId() {
    return companyId;
  }

  String getSubject() {
    return subject;
  }
}
