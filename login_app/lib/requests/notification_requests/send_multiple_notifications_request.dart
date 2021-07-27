import 'package:login_app/subsystems/notification_subsystem/tempNotification.dart';

class SendMultipleNotificationRequest {
  List<TempNotification> list;

  SendMultipleNotificationRequest(List<TempNotification> notifList) {
    this.list = notifList;
  }

  List<TempNotification> getList() {
    return list;
  }
}
