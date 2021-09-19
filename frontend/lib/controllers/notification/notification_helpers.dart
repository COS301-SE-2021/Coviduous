import 'package:frontend/models/notification/temp_notification.dart';

import 'package:frontend/controllers/notification/notification_controller.dart' as notificationController;
import 'package:frontend/globals.dart' as globals;

Future<bool> getNotifications() async {
  bool result = false;
  await Future.wait([
    notificationController.getNotificationsUserEmail(globals.loggedInUserEmail)
  ]).then((results) {
    if (results.first != null) {
      globals.currentNotifications = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> createNotification(TempNotification tempUser) async {
  bool result = false;
  await Future.wait([
    notificationController.createNotification("", tempUser.getUserId(), tempUser.getUserEmail(), globals.currentSubjectField,
        globals.currentMessageField, "", globals.loggedInUser.getFirstName() + " " + globals.loggedInUser.getLastName(), globals.loggedInCompanyId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> createNotifications(List<TempNotification> tempUsers) async {
  bool result = false;
  for (int i = 0; i < tempUsers.length; i++) {
    result = await createNotification(tempUsers[i]);
  }
  return result;
}