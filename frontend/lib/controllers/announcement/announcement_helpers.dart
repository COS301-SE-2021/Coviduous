import 'package:frontend/controllers/announcement/announcement_controller.dart' as announcementController;
import 'package:frontend/globals.dart' as globals;

Future<bool> createAnnouncement(String type, String description) async {
  bool result = false;
  await Future.wait([
    announcementController.createAnnouncement(" ", type, description, " ")
  ]).then((results) {
    result = results.first;
  });
  return result;
}

Future<bool> getAnnouncements() async {
  bool result = false;
  await Future.wait([
    announcementController.getAnnouncements()
  ]).then((results) {
    if (results.first != null) {
      globals.currentAnnouncements = results.first;
      result = true;
    }
  });
  return result;
}

Future<bool> deleteAnnouncement(String announcementId) async {
  bool result = false;
  await Future.wait([
    announcementController.deleteAnnouncement(announcementId)
  ]).then((results) {
    result = results.first;
  });
  return result;
}