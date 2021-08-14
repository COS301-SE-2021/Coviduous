import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controllers/announcement_controller.dart'
    as announcementController;
import 'package:frontend/models/announcement/announcement.dart';

void main() {
  String expectedType;
  String expectedMessage;
  String expectedAdminId;
  String expectedCompanyId;

  setUp(() {
    expectedType = "test";
    expectedMessage = "test";
    expectedAdminId = "test";
    expectedCompanyId = "test";
  });

  tearDown(() {});

  // ======================HTTP SERVER TESTING======================== //

  test('Create announcement', () async {
    bool value = await announcementController.createAnnouncement("",
        expectedType, expectedMessage, "");

    expect(value, isNot(null));
    expect(true, value);
  });

  test('View announcement', () async {
    List<Announcement> list = await announcementController.getAnnouncements();

    for (var data in list) {
      print(data.announcementId);
    }

    //expect(list, isNot(null));
  });

  test('Delete announcement', () async {
    bool value = await announcementController.createAnnouncement("",
        expectedType, expectedMessage, "");

    List<Announcement> list = await announcementController.getAnnouncements();

    // for (var data in list) {
    //   print(data.announcementId);
    // }

    String announcementId = list[list.length - 1].announcementId;

    bool value2 =
        await announcementController.deleteAnnouncement(announcementId);

    expect(value2, isNot(null));
    expect(true, value2);
  });
}
