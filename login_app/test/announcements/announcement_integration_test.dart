import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';

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
    expectedAdminID = "test-1";
    expectedCompanyID = "test-1";
  });

  tearDown(() async {
    
  });

  group('Create Announcement', () {
    test('Correct create announcement', () async {
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
          expectedType, expectedMessage, expectedAdminID, 'Invalid_company_ID');
      CreateAnnouncementResponse resp =
          await announcementController.createAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      //print("AnnouncementID : " + resp.getAnnouncementID());
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });
  });

  /*
  group('View Announcement', () {
    test('Correct view announcement', () async {
      ViewAdminAnnouncementRequest req =
          new ViewAdminAnnouncementRequest('test');
      ViewAdminAnnouncementResponse resp =
          await announcementController.viewAdminAnnouncement(req);

      print("Response : " + resp.getResponseMessage());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });

    test('Invalid viewAnnouncement request', () async {
      ViewAdminAnnouncementRequest req = null;
      ViewAdminAnnouncementResponse resp =
          await announcementController.viewAdminAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());

      //expect exception handling
      //expect(await resp, throwsA("Announcement unsuccessfully created"));
      expect(false, resp.getResponse());
    });

    test('Invalid Announcement ID on viewing announcement', () async {
      ViewAdminAnnouncementRequest req =
          new ViewAdminAnnouncementRequest('Invalid_announcement_id');
      ViewAdminAnnouncementResponse resp =
          await announcementController.viewAdminAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());
      //print("AnnouncementID : " + resp.getAnnouncementID());
      expect(resp, isNot(null));
      expect(false, resp.getResponse());
    });
  });
   */

  group('Delete Announcement', () {
    test('Correct delete announcement', () async {
      DeleteAnnouncementRequest req =
          new DeleteAnnouncementRequest('ANOUNC-1729');
      DeleteAnnouncementResponse resp =
          await announcementController.deleteAnnouncement(req);

      print("Response : " + resp.getResponseMessage());

      expect(resp, isNot(null));
      expect(true, resp.getResponse());
    });

    test('Invalid deleteAnnouncement request', () async {
      DeleteAnnouncementRequest req = null;
      DeleteAnnouncementResponse resp =
          await announcementController.deleteAnnouncement(req);

      //print("Response : " + resp.getResponseMessage());

      //expect exception handling
      //expect(await resp, throwsA("Announcement unsuccessfully created"));
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
  
}
