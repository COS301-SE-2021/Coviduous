//import '../../lib/backend/server_connections/announcement_data_base_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:postgres/postgres.dart';
import 'package:login_app/backend/globals/announcements_globals.dart'
    as globals;

void main() {
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

/////////////////////////////////////////////////////////////////////////////////
  test('Create Announcement Mock', () async {
    var announcementController = AnnouncementsController();
    CreateAnnouncementRequest req = new CreateAnnouncementRequest(
        "General", "Please Register For PaySlips", "USRAD-1", "CID-1");
    CreateAnnouncementResponse resp =
        announcementController.createAnnouncementMock(req);
    print("Response : " + resp.getResponseMessage());
    print("AnnouncementID : " + resp.getAnnouncementID());

    expect(globals.numAnnouncements, isNot(0));
  });
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
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
}
