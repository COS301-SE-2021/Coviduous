import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/backend/controllers/announcements_controller.dart';
import 'package:frontend/backend/server_connections/announcement_data_base_queries.dart';
import 'package:frontend/requests/announcements_requests/create_announcement_request.dart';
import 'package:frontend/requests/announcements_requests/delete_announcement_request.dart';
import 'package:frontend/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:frontend/responses/announcement_responses/create_announcement_response.dart';
import 'package:frontend/responses/announcement_responses/delete_announcement_response.dart';
import 'package:frontend/responses/announcement_responses/viewAdmin_announcement_response.dart';

void main() {
  AnnouncementsController announcementController =
      new AnnouncementsController();

  String expectedValue;
  String expectedType;
  String expectedMessage;
  String expectedAdminID;
  String expectedCompanyID;

  setUp(() async {
    expectedValue = "test-1";
    expectedType = "General";
    expectedMessage = "This is a test announcement message";
    expectedAdminID = "ADMN-1";
    expectedCompanyID = "CMPNY-1";
  });

  tearDown(() async {
    // await connection.close();
  });

  test('Correct create announcement', () async {
    // Run user int. tests first to insert data to users table

    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        expectedType, expectedMessage, expectedAdminID, expectedCompanyID);
    CreateAnnouncementResponse resp =
        await announcementController.createAnnouncementAPI(req);

    //print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());

    expect(resp, isNot(null));
    expect(true, resp.getResponse());
  });

  test('Correct view announcement', () async {
    // Run user int. tests first to insert data to users table
    AnnouncementDatabaseQueries model = new AnnouncementDatabaseQueries();
    bool holder = await model.viewAnnouncementsAdminAPI("test2");

    expect(model.globalAnnouncements.length, isNot(0));
    expect(true, holder);
  });
}
