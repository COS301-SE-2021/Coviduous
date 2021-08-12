//import '../../lib/backend/server_connections/announcement_data_base_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/controllers/announcement_controller.dart'
    as announcementController;
import 'package:frontend/subsystems/announcement_subsystem/announcement2.dart';

void main() {
  // AnnouncementsController announcementController =
  //     new AnnouncementsController();

  String expectedValue = "test";
  String expectedType;
  String expectedMessage;
  String expectedAdminId;
  String expectedCompanyId;

  setUp(() async {
    expectedValue = "test";
  });

  tearDown(() async {});

  // ======================HTTP SERVER TESTING======================== //

  test('Create announcement', () async {
    //print(results);

    //expect(results.length, isNot(0));
  });

  test('View announcement', () async {
    List<Announcement> list = await announcementController.getAnnouncements();

    for (var data in list) {
      print(data.announcementId);
    }
    //print(results);

    //expect(results.length, isNot(0));
  });

  // test('Delete announcement', () async {

  //   print(results);

  //   expect(results.length, 0);
  // });
}
