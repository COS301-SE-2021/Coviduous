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

  bool createAnnouncement() {
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
