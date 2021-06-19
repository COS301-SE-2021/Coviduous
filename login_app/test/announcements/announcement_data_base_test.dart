//import '../../lib/backend/server_connections/announcement_data_base_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_app/backend/controllers/announcements_controller.dart';
import 'package:login_app/requests/announcements_requests/create_announcement_request.dart';
import 'package:login_app/responses/announcement_responses/create_announcement_response.dart';
import 'package:postgres/postgres.dart';

void main() {
  PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = 'postgres'; // your postgres user password

  AnnouncementsController announcementController =
      new AnnouncementsController();

  String expectedValue = "test";
  // String expectedType;
  // String expectedMessage;
  // String expectedAdminID;
  // String expectedCompanyID;

  setUp(() async {
    expectedValue = "test";

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

  // ======================DB TESTING======================== //

  test('Successful database connection', () async {
    expect(expectedMessage, "Connected to postgres database...");
    expect(await connection.execute('select 1'), equals(1));
  });

  test('Create announcement', () async {
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

    print(results);

    expect(results.length, isNot(0));
  });

  test('View announcement', () async {
    var results = await connection.query("SELECT * FROM announcements");

    print(results);

    expect(results.length, isNot(0));
  });

  test('Delete announcement', () async {
    var results = await connection.query(
        "DELETE FROM announcements WHERE announcementid = @id",
        substitutionValues: {'id': expectedValue});

    print(results);

    expect(results.length, 0);
  });
}
