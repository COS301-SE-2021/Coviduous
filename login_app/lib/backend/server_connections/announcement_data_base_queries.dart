import 'package:mongo_dart/mongo_dart.dart';
import 'package:postgres/postgres.dart';

import 'dart:math';

class AnnouncementDatabaseQueries {
  PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = ' '; // your postgres user password

  String announcementID;
  String timestamp;

  AnnouncementDatabaseQueries() {
    announcementID = null;
    timestamp = null;
  }

  void setAnnouncementID(String aID) {
    this.announcementID = aID;
  }

  void setTimestamp(String timestamp) {
    this.timestamp = timestamp;
  }

  String getAnnouncementID() {
    return announcementID;
  }

  String getTimestamp() {
    return timestamp;
  }

  // DB connection function to be called in each use case - need to test
  Future connect() async {
    connection = PostgreSQLConnection(host, port, dbName,
        username: user, password: pass);

    try {
      await connection.open();
      print("Connected to postgres database...");
    } catch (e) {
      print("error");
      print(e.toString());
    }
  }

  Future<bool> createAnnouncement(
      String type, String message, String adminID, String companyID) async {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    String announcementID = "ANOUNC-" + randomInt.toString();
    String timestamp = DateTime.now().toString();

    connect(); // connect to db

    var result = await connection
        .query('''INSERT INTO announcements (announcementid, type, datecreated, message, adminid, companyid)
                                  VALUES (@id, @type, @date, @message, @adminid, @companyid)''',
            substitutionValues: {
          'id': announcementID,
          'type': type,
          'date': timestamp,
          'message': message,
          'adminid': adminID,
          'companyid': companyID,
        });

    if (result != null) {
      setAnnouncementID(announcementID);
      setTimestamp(timestamp);

      return true;
    }

    return false;
  }

  void viewAnnouncements() //arraylist
  {}

  void deleteAnnouncement(String announcementId) async {
    var db = Db("mongodb://localhost:27017/test");
    await db.open();
    DbCollection coll = db.collection('people');
    print('Connected to database');
    await coll.remove(coll.findOne(where.eq("first_name", announcementId)));
    print('Deleted from database');
    // return true;
  }
}
