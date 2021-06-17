//import '../../lib/backend/server_connections/announcement_data_base_queries.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:postgres/postgres.dart';

void main() {
  PostgreSQLConnection connection;
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
  
}
