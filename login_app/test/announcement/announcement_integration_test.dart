import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';

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

    // connect to db
    // connection = PostgreSQLConnection(host, port, dbName,
    //     username: user, password: pass);

    // try {
    //   await connection.open();
    //   expectedMessage = "Connected to postgres database...";
    //   print(expectedMessage);
    // } catch (e) {
    //   print("error");
    //   print(e.toString());
    // }
  });

  tearDown(() async {
    // await connection.close();
  });

  group('Create Announcement', () {
    test('Correct create announcement', () async {
      // Run user int. tests first to insert data to users table

      CreateAnnouncementRequest req = new CreateAnnouncementRequest(
          expectedType, expectedMessage, expectedAdminID, expectedCompanyID);
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      print("AnnouncementID : " + resp.getAnnouncementID());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });

    test('Invalid createAnnouncement request', () async {
      CreateAnnouncementRequest req = null;
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());

      //expect exception handling
      //expect(await resp, throwsA("Announcement unsuccessfully created"));
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });

    test('Invalid Admin ID on announcement creation', () async {
      CreateAnnouncementRequest req = new CreateAnnouncementRequest(
          expectedType, expectedMessage, 'Invalid_admin_ID', expectedCompanyID);
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      //print("AnnouncementID : " + resp.getAnnouncementID());
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });

    test('Invalid Company ID on announcement creation', () async {
      CreateAnnouncementRequest req = new CreateAnnouncementRequest(
          expectedType,
          expectedMessage,
          'Invalid_admin_ID',
          'Invalid_company_ID');
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      print("Response : " + resp.getResponseMessage());
      //print("AnnouncementID : " + resp.getAnnouncementID());
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });
  });

  group('Delete Announcement', () {
    test('Correct delete announcement', () async {
      // CREATE AN ANNOUNCEMENT
      CreateAnnouncementRequest req = new CreateAnnouncementRequest(
          expectedType, expectedMessage, expectedAdminID, expectedCompanyID);
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      print("AnnouncementID : " + resp.getAnnouncementID());

      // DELETE CREATED ANNOUNCEMENT
      DeleteAnnouncementRequest req2 =
          new DeleteAnnouncementRequest(resp.getAnnouncementID());
      DeleteAnnouncementResponse resp2 =
          await announcementController.deleteAnnouncement(req2);

      print("Response : " + resp2.getResponseMessage());

      // create announcement responses
      expect(resp, isNot(null));
      expect(true, resp.getResponse());
      // delete announcement responses
      expect(resp2, isNot(null));
      expect(true, resp2.getResponse());
    });

    test('Invalid deleteAnnouncement request', () async {
      DeleteAnnouncementRequest req = null;
      DeleteAnnouncementResponse resp =
          await announcementController.deleteAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());

      //expect exception handling
      //expect(await resp, throwsA("Announcement unsuccessfully created"));
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });

    test('Invalid Announcement ID on announcement deletion', () async {
      DeleteAnnouncementRequest req =
          new DeleteAnnouncementRequest('Invalid_announcement_id');
      DeleteAnnouncementResponse resp =
          await announcementController.deleteAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      //print("AnnouncementID : " + resp.getAnnouncementID());
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });
  });

  group('View Announcement', () {
    test('Correct view announcement', () async {
      // CREATE AN ANNOUNCEMENT
      CreateAnnouncementRequest req = new CreateAnnouncementRequest(
          expectedType, expectedMessage, expectedAdminID, expectedCompanyID);
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      print("AnnouncementID : " + resp.getAnnouncementID());

      // VIEW CREATED ANNOUNCEMENT
      ViewAdminAnnouncementRequest req2 =
          new ViewAdminAnnouncementRequest(expectedAdminID);
      ViewAdminAnnouncementResponse resp2 =
          await announcementController.viewAdminAnnouncement(req2);

      //print("Response : " + resp2.getMessage());

      // create announcement responses
      expect(resp, isNot(null));
      expect(true, resp.getResponse());
      // view announcement responses
      expect(resp2, isNot(null));
      expect(true, resp2.getResponse());
    });

    test('Invalid viewAnnouncement request', () async {
      ViewAdminAnnouncementRequest req = null;
      ViewAdminAnnouncementResponse resp =
          await announcementController.viewAdminAnnouncement(req);

      //expect exception handling
      //expect(await resp, throwsA("Announcement unsuccessfully created"));
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });

    test('Invalid Admin ID on viewing announcement', () async {
      ViewAdminAnnouncementRequest req =
          new ViewAdminAnnouncementRequest('Invalid_admin_ID');
      ViewAdminAnnouncementResponse resp =
          await announcementController.viewAdminAnnouncement(req);

      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });
  });
  
}
