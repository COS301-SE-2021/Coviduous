//import '../../lib/backend/server_connections/announcement_data_base_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/delete_announcement_request.dart';
import 'package:login_app/requests/announcements_requests/viewAdmin_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/delete_announcement_response.dart';
import 'package:login_app/responses/announcement_responses/viewAdmin_announcement_response.dart';
import 'package:postgres/postgres.dart';
import 'package:login_app/backend/globals/announcements_globals.dart'
    as globals;

void main() {
  /////////////////////////////////// These Are Unit Tests To Test Concrete Implementations For Announcements ////////////////////
  /*PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = ' '; // your postgres user password

  String expectedValue;
  String expectedMessage;

  setUp(() async {
    expectedValue = "test3";

    // connect to db
    connection = PostgreSQLConnection(host, port, dbName,
        username: user, password: pass);

    try {
      await connection.open();
      expectedMessage = "Connected to postgres database...";
      print(expectedMessage);
    } catch (e) {
      print("error");
      print(e.toString());
    }
  });

  tearDown(() async {
    await connection.close();
  });

  test('Database connection', () async {
    expect(expectedMessage, "Connected to postgres database...");
    expect(await connection.execute('select 1'), equals(1));
  });

  test('Create announcement', () async {
    // to replace with actual createAnnouncement use case handling function maybe
    await connection
        .query('''INSERT INTO announcements (announcementid, type, datecreated, message, adminid, companyid)
                                  VALUES (@id, @type, @date, @message, @adminid, @companyid)''',
            substitutionValues: {
          'id': expectedValue,
          'type': expectedValue,
          'date': expectedValue,
          'message': expectedValue,
          'adminid': expectedValue,
          'companyid': expectedValue,
        });

    var results = await connection.query("SELECT * FROM announcements");

    //print(results);
    //print(results[0][0]);

    // expect on use case responses -> expect(expectedResponse, resp.getResponse())
    expect(results.length, isNot(0));
  });*/

  /*test('View announcement', () async {
    // to replace with actual viewAnnouncement use case handling function maybe
    var results = await connection.query("SELECT * FROM announcements");

    print(results);
    //print(results[0]);

    // expect on use case responses -> expect(expectedResponse, resp.getResponse())
    expect(results.length, isNot(0));
  });

  test('Delete announcement', () async {
    // to replace with actual deleteAnnouncement use case handling function maybe
    var results = await connection.query(
        "DELETE FROM announcements WHERE announcementid = @id",
        substitutionValues: {'id': expectedValue});

    //print(results);
    //print(results[0]);

    // expect on use case responses -> expect(expectedResponse, resp.getResponse())
    expect(results.length, 0);
  });*/

///////////////////////////////////// These Unit Tests Test Mocked Functionality For The Announcement System ///////////
////////////////////////////////////////////// Create Announcement/////////////////////////////////////////////////////
  test('Create Announcement Mock', () {
    var announcementController = AnnouncementsController();
    print(
        "/////////////////////////////Testing Mock Create Announcement ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());

    print(
        "/////////////////////////////Completed Mock Testing For Creating Announcements ///////////////////");
    expect(globals.numAnnouncements, isNot(0));
  });
  ////////////////////////////////////////////// Delete Announcement  /////////////////////////////////////////////////////

  test('Delete Announcement Mock', () {
    var announcementController = AnnouncementsController();
    print(
        "/////////////////////////////Testing Mock delete Announcement ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());
    print("Successfully created announcement will now attempt to delete it");

    DeleteAnnouncementRequest delReq =
        new DeleteAnnouncementRequest(resp.getAnnouncementID());

    DeleteAnnouncementResponse delResp =
        announcementController.deleteAnnouncementMock(delReq);
    print("Response : " + delResp.getResponseMessage());

    print(
        "/////////////////////////////Completed Mock Test For Delete ///////////////////");
    //number of announcement should be zero since we only made 1 announcement and the deleted it.
    expect(globals.numAnnouncements, 0);
  });
  /////////////////////////////////////////////// View Announcement Admin /////////////////////////////////////////////////////
  test('View Announcement For Admin Mock', () {
    var announcementController = AnnouncementsController();

    print(
        "/////////////////////////////Testing Mock Admin View Announcements ///////////////////");
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "GENERAL", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());
    print("Successfully created announcement ");

    //SECOND ANNOUNCEMENT WAS ADMINISTERED BY A DIFFERENT ADMIN WITH ID=USRAD-2
    CreateAnnouncementRequest req2 =
        new CreateAnnouncementRequest("GENERAL", "", "USRAD-2", "CID-2");
    CreateAnnouncementResponse resp2 =
        announcementController.createAnnouncementMock(req2);
    print("Response : " + resp2.getResponseMessage());
    print("AnnouncementID : " + resp2.getAnnouncementID());
    print("Successfully created announcement ");

    //THIRD ANNOUNCEMENT WAS ADMINISTERED BY ADMIN WITH ID=USRAD-1 WHICH IS THE SAME AS THE FIRST ANNOUNCEMENT
    CreateAnnouncementRequest req3 = new CreateAnnouncementRequest(
        "EMERGENCY",
        "THE OFFICES HAVE BEEN FOUND TO HAVE TRACES OF COVID-19",
        "USRAD-1",
        "CID-1");
    CreateAnnouncementResponse resp3 =
        announcementController.createAnnouncementMock(req3);
    print("Response : " + resp3.getResponseMessage());
    print("AnnouncementID : " + resp3.getAnnouncementID());
    print("Successfully created announcement ");
    print(
        "/////////////////////////////Successfully added announcements ///////////////////");
    ViewAdminAnnouncementRequest viewReq =
        new ViewAdminAnnouncementRequest("USRAD-1");

    ViewAdminAnnouncementResponse viewResp =
        announcementController.viewAnnouncementsAdminMock(viewReq);
    print("Response : " + viewResp.getMessage());
    if (viewResp.getAdminAnnouncements() != null) {
      var list = viewResp.getAdminAnnouncements();
      for (var j = 0; j < list.length; j++) {
        print("Printing Admin Announcement");
        print("Message : " + list[j].getMessage());
        print("Date : " + list[j].getDate());
        print("Type : " + list[j].getType());
        print("Announcement ID : " + list[j].getAnnouncementId());
        print("Admin ID : " + list[j].getadminId());
        print("Company ID : " + list[j].getCompanyId());
      }
    }

    print(
        "/////////// Completed View Announcement For Admin Mock Test //////////////////////");
    //number of announcement should be not be zero since 3 announcements were added.
    expect(globals.numAnnouncements, isNot(0));
  });
}
