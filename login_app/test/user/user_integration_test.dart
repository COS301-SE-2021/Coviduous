import 'package:flutter_test/flutter_test.dart';
import 'package:postgres/postgres.dart';

void main() {
  PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = 'postgres'; // your postgres user password

  String expectedValue;
  String expectedUpdate;
  String expectedMessage;
  String expectedUserID;
  String expectedAdminID;
  String expectedCompanyID;

  setUp(() async {
    expectedValue = "test-1";
    expectedUpdate = "test-2";
    expectedUserID = "USR-1";
    expectedAdminID = "ADMN-1";
    expectedCompanyID = "CMPNY-1";

    //connect to db
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

  test('Successful Database connection', () async {
    expect(expectedMessage, "Connected to postgres database...");
    expect(await connection.execute('select 1'), equals(1));
  });

  test('Correct Register User', () async {
    await connection
        .query('''INSERT INTO users (userid, type, firstName, lastName, username, email, password, activationcode, adminid, companyid)
                                  VALUES (@id, @type, @fName, @lName, @username, @email, @pass, @a_code, @a_id, @c_id)''',
            substitutionValues: {
          'id': expectedUserID,
          'type': expectedValue,
          'fName': expectedValue,
          'lName': expectedValue,
          'username': expectedValue,
          'email': expectedValue,
          'pass': expectedValue,
          'a_code': expectedValue,
          'a_id': expectedAdminID,
          'c_id': expectedCompanyID,
        });

    var results = await connection.query("SELECT * FROM users");

    //print(results);

    expect(results.length, isNot(0));
  });

  test('Correct Register Company', () async {
    await connection
        .query('''INSERT INTO company (companyid, name, address, adminid)
                                  VALUES (@id, @name, @address, @a_id)''',
            substitutionValues: {
          'id': expectedCompanyID,
          'name': expectedValue,
          'address': expectedValue,
          'a_id': expectedAdminID,
        });

    var results = await connection.query("SELECT * FROM company");

    //print(results);

    expect(results.length, isNot(0));
  });

  test('Correct Update account info', () async {
    var results = await connection.query(
        "UPDATE users SET firstName = @fName, lastName = @lName, email = @email WHERE userid = @id",
        substitutionValues: {
          'id': expectedUserID,
          'fName': expectedUpdate,
          'lName': expectedUpdate,
          'email': expectedUpdate,
        });

    //print(results);

    expect(results.length, 0);
  });

  test('Correct reset password', () async {
    var results = await connection.query(
        "UPDATE users SET password = @pass WHERE userid = @id",
        substitutionValues: {'id': expectedUserID, 'pass': expectedUpdate});

    //print(results);

    expect(results.length, 0);
  });

  test('Correct Delete User Account', () async {
    var results = await connection.query("DELETE FROM users WHERE userid = @id",
        substitutionValues: {'id': expectedUserID});

    //print(results);

    expect(results.length, 0);
  });



}
