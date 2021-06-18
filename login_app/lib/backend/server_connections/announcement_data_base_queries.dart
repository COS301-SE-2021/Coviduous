import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as globals;
import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
//import 'package:postgres/postgres.dart';

import 'dart:math';

class AnnouncementDatabaseQueries {
  //PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = ' '; // your postgres user password

  String announcementID;
  String timestamp;
  String companyIdentification;

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
  // Future connect() async {
  //   connection = PostgreSQLConnection(host, port, dbName,
  //       username: user, password: pass);

  //   try {
  //     await connection.open();
  //     print("Connected to postgres database...");
  //   } catch (e) {
  //     print("error");
  //     print(e.toString());
  //   }
  // }

  // Future<bool> createAnnouncement(
  //     String type, String message, String adminID, String companyID) async {
  //   int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
  //   String announcementID = "ANOUNC-" + randomInt.toString();
  //   String timestamp = DateTime.now().toString();

  //   connect(); // connect to db

  //   var result = await connection
  //       .query('''INSERT INTO announcements (announcementid, type, datecreated, message, adminid, companyid)
  //                                 VALUES (@id, @type, @date, @message, @adminid, @companyid)''',
  //           substitutionValues: {
  //         'id': announcementID,
  //         'type': type,
  //         'date': timestamp,
  //         'message': message,
  //         'adminid': adminID,
  //         'companyid': companyID,
  //       });

  //   if (result != null) {
  //     setAnnouncementID(announcementID);
  //     setTimestamp(timestamp);

  //     return true;
  //   }

  //   return false;
  // }
/////////////////////////////////////////// END OF CONCRETE IMPLEMENTATIONS BEGIN MOCK IMPLEMENTATIONS FOR THE CONCRETE FUNCTIONS////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * This function mocks out the database interaction of creating an announcement, the fuction will be used in tests
 */
  bool createAnnouncementMock(
      String message, String type, String adminID, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.announcementID = "ANOUNC-" + randomInt.toString();
    this.timestamp = DateTime.now().toString();

    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false) {
      //set up your prepared statement

      var announcement1 = new Announcement(this.announcementID, type,
          this.timestamp, message, adminID, companyID);
      globals.announcementDatabaseTable.add(announcement1);
      print("Added a new announcement");
      //execute sql statement
      globals.numAnnouncements++;
      print("Number of announcements : " + globals.numAnnouncements.toString());
      return true;
    } else {
      //This means connection could not be established
      return false;
    }
  }

  void viewAnnouncements() //arraylist
  {}
/////////////////////////////////////////////////////////////////////////////////////////////////
//Delete Announcement Mock
  bool deleteAnnouncementMock(String announcementId) {
    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false) {
      //set up your prepared statement
      for (var i = 0; i < globals.announcementDatabaseTable.length; i++) {
        if (globals.announcementDatabaseTable[i].getAnnouncementId() ==
            announcementId) {
          print("Removed Announcement");
          globals.announcementDatabaseTable.removeAt(i);
          globals.numAnnouncements--;
        } else {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////
  /// View Announcements For The admin to view their assosiated announcements
  List<Announcement> viewAnnouncementsAdminMock(String adminId) {
    List<Announcement> resultSet = [];
    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false && adminId != "") {
      //set up prepared statement.
      //execute prepared statement to fetch all announcements with specified announcement Id
      //this loop mocks the functionality of fetching assosiated announcements from the database
      for (var i = 0; i < globals.announcementDatabaseTable.length; i++) {
        if (globals.announcementDatabaseTable[i].getadminId() == adminId) {
          if (globals.announcementDatabaseTable[i] != null) {
            resultSet.add(globals.announcementDatabaseTable[i]);
          }
        }
      }
      return resultSet;
    } else {
      return null;
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////
  /// View Announcements For The User to view their company assosiated announcements
  List<Announcement> viewAnnouncementsUserMock(String userId) {
    List<Announcement> resultSet = [];
    this.companyIdentification = "";

    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false && userId != "") {
      //set up prepared statement.
      //execute prepared statement to fetch the users companyid announcements for assosiated announcements to the company
      //this loop mocks the functionality of fetching assosiated companyid from the database

      for (var i = 0; i < globals.userDatabaseTable.length; i++) {
        if (globals.userDatabaseTable[i].getUserId() == userId) {
          if (globals.userDatabaseTable[i] != null) {
            this.companyIdentification =
                globals.userDatabaseTable[i].getCompanyId();
            print("Found Users Company ID : " + companyIdentification);
          }
        }
      }

      //once the companyId is fetched we can use it to query for all announcements assosiated with that company that the user is listed under
      for (var i = 0; i < globals.announcementDatabaseTable.length; i++) {
        if (globals.announcementDatabaseTable[i].getCompanyId() ==
            this.companyIdentification) {
          if (globals.announcementDatabaseTable[i] != null) {
            resultSet.add(globals.announcementDatabaseTable[i]);
            print("Company Announcement Added");
          }
        }
      }
      return resultSet;
    } else {
      return null;
    }
  }
}
