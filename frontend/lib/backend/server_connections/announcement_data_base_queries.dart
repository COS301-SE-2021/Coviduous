/*
  * File name: announcement_data_base_queries.dart
  
  * Purpose: Provides an interface to all the announcement service contracts of the system
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'package:frontend/backend/backend_globals/announcements_globals.dart'
    as globals;
import 'package:frontend/backend/backend_globals/user_globals.dart'
    as userGlobals;
import 'package:frontend/frontend/front_end_globals.dart' as frontEndGlobals;
import 'package:frontend/subsystems/announcement_subsystem/announcement.dart';
import 'package:postgres/postgres.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

/**
 * Class name: AnnouncementDatabaseQueries
 * 
 * Purpose: This class provides an interface to all the announcement service contracts of the system. It provides a bridge between the frontend screens and backend functionality for office.
 * 
 * The class has both mock and concrete implementations of the service contracts.
 */
class AnnouncementDatabaseQueries {
  PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = 'postgres'; // your postgres user password
  var testJson = json.encode({
    "data": [
      {
        "data": {
          "announcents": {
            "type": "test2",
            "timestamp": "test2",
            "announcementId": "test2",
            "message": "test2",
            "adminId": "test2",
            "id": "OBlVZojg",
            "companyId": "test2"
          }
        }
      },
      {
        "data": {
          "announcents": {
            "type": "test1",
            "adminId": "test1",
            "announcementId": "test1",
            "id": "OBlVZojg94NlTV5GDfQa",
            "message": "test1",
            "companyId": "test1",
            "timestamp": "test1"
          }
        }
      },
      {
        "data": {
          "announcents": {
            "companyId": "test2",
            "announcementId": "test2",
            "adminId": "test2",
            "message": "test2",
            "id": "announc",
            "type": "test2",
            "timestamp": "test2"
          }
        }
      },
      {
        "data": {
          "announcents": {
            "timestamp": "test2",
            "companyId": "test2",
            "message": "test2",
            "announcementId": "hvgvfxrt",
            "id": "undefined",
            "type": "test2",
            "adminId": "test2"
          }
        }
      }
    ]
  });
  List<Announcement> globalAnnouncements = [];
  int numAnnouncements = 0;
  String announcementId;
  String timeStamp;
  String companyIdentification;

  AnnouncementDatabaseQueries() {
    announcementId = null;
    timeStamp = null;
  }
//////////////////////////////////////////////DEMO3 API CLOUD FUNCTIONS ////////////////////////////////////////////////

  Future<bool> createAnnouncementAPI(
      String type, String message, String adminId, String companyId) async {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.announcementId = "ANOUNC-" + randomInt.toString();
    this.timeStamp = DateTime.now().toString();
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://localhost:5001/frontend-api/us-central1/app/api/announcement/view-announcements'));
    request.body = request.body = json.encode({
      "id": announcementId,
      "announcementId": announcementId,
      "type": type,
      "message": message,
      "timestamp": timeStamp,
      "adminId": adminId,
      "companyId": companyId
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  bool convertJsonToAnnouncementList(dynamic json) {
    //NB on json announcements is spelt wrong announcents
    globalAnnouncements = [];
    numAnnouncements = 0;
    for (int i = 0; i < json.length; i++) {
      Announcement holder = new Announcement(
          json[i].data.announcents['announcementId'],
          json[i].data.announcents['type'],
          json[i].data.announcents['timestamp'],
          json[i].data.announcents['message'],
          json[i].data.announcents['adminId'],
          json[i].data.announcents['companyId']);
      globalAnnouncements.add(holder);
      numAnnouncements++;
      print("added");
    }
    if (numAnnouncements > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> viewAnnouncementsAdminAPI(String floorNo) async {
    var headers = {'Content-Type': 'application/json'};
    /* var request = http.Request(
        'GET',
        Uri.parse(
            'http://localhost:5001/frontend-api/us-central1/app/api/announcement/view-announcements'));
    request.body = json.encode({"floorNo": floorNo});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      String lst = (await response.stream.bytesToString()).toString();
      dynamic str = jsonDecode(lst);
      return convertJsonToAnnouncementList(str["data"]);
    } else {
      print(response.reasonPhrase);
      return false;
    }*/
    return convertJsonToAnnouncementList(testJson);
  }

  ////////////////////////////////////////DEMO 1 AND 2 POSTGRES INTERGRATION //////////////////////////////////////////
  // DB connection function to be called in each use case
  Future<void> connect() async {
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

//////////////////////////////////Concerete Implementations///////////////////////////////////

/**
 * This function allows the admin the ability to create an announcement
 */
  Future<bool> createAnnouncement(
      String type, String message, String adminID, String companyID) async {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.announcementId = "ANOUNC-" + randomInt.toString();
    this.timeStamp = DateTime.now().toString();
    await connect(); // connect to db

    var adminIDQuery = await connection.query(
        "SELECT adminid FROM users WHERE adminid = @id",
        substitutionValues: {'id': adminID});

    var companyIDQuery = await connection.query(
        "SELECT companyid FROM users WHERE adminid = @id",
        substitutionValues: {'id': adminID});

    // check if given adminID && companyID exist in DB
    if (adminIDQuery.length != 0 && companyIDQuery.length != 0) {
      // ignore: unused_local_variable
      var result = await connection
          .query('''INSERT INTO announcements (announcementid, type, datecreated, message, adminid, companyid)
                                  VALUES (@id, @type, @date, @message, @adminid, @companyid)''',
              substitutionValues: {
            'id': announcementId,
            'type': type,
            'date': timeStamp,
            'message': message,
            'adminid': adminID,
            'companyid': companyID,
          });

      if (result != null) {
        setAnnouncementID(announcementId);
        setTimestamp(timeStamp);

        return true;
      }
    }

    return false;
  }

/////////////////////////////////////////////////////////////////////////////////////
/**
 * This function allows the admin to view the announcements they issued to their employees
 */
  Future<bool> viewAdminAnnouncement(String adminID) async {
    await connect(); // connect to db

    var adminIDQuery = await connection.query(
        "SELECT adminid FROM users WHERE adminid = @id",
        substitutionValues: {'id': adminID});

    // check if given adminID exist in DB
    if (adminIDQuery.length != 0) {
      var result = await connection.query(
          "SELECT * FROM announcements WHERE adminid = @id",
          substitutionValues: {'id': adminID});

      if (result != null) {
        return true;
      }
    }
    return false;
  }

////////////////////////////////////////////////////////////
/**
 * This function allows the admin to delete an announcement using the announcement ID
 */
  Future<bool> deleteAnnouncement(String announcementID) async {
    await connect(); // connect to db

    var announcementIDQuery = await connection.query(
        "SELECT announcementid FROM announcements WHERE announcementid = @id",
        substitutionValues: {'id': announcementID});

    // check if given announcementID exist in DB
    if (announcementIDQuery.length != 0) {
      var result = await connection.query(
          "DELETE FROM announcements WHERE announcementid = @id",
          substitutionValues: {'id': announcementID});

      if (result != null) {
        return true;
      }
    }

    return false;
  }

//////////////////////////////Getters and Setters//////////////////////////////
  void setAnnouncementID(String aID) {
    this.announcementId = aID;
  }

  void setTimestamp(String timestamp) {
    this.timeStamp = timestamp;
  }

  String getAnnouncementID() {
    return announcementId;
  }

  String getTimestamp() {
    return timeStamp;
  }

///////////////////////// END OF CONCRETE IMPLEMENTATIONS BEGIN MOCK IMPLEMENTATIONS FOR THE CONCRETE FUNCTIONS ////////////////////
//////////////////////////////////Mock Implementations///////////////////////////////////

/**
 * This function mocks out the database interaction of creating an announcement, the fuction will be used in tests
 */
  bool createAnnouncementMock(
      String type, String message, String adminID, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    this.announcementId = "ANOUNC-" + randomInt.toString();
    this.timeStamp = DateTime.now().toString();

    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false) {
      //set up your prepared statement

      var announcement1 = new Announcement(this.announcementId, type,
          this.timeStamp, message, adminID, companyID);
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

/////////////////////////////////////////////////////////////////////////////////////////////////
//Delete Announcement Mock
  bool deleteAnnouncementMock(String announcementId) {
    // connection to DB
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

    if (connection) {
      //set up prepared statement.
      //execute prepared statement to fetch the users companyid announcements for assosiated announcements to the company
      //this loop mocks the functionality of fetching assosiated companyid from the database

      for (var i = 0; i < userGlobals.userDatabaseTable.length; i++) {
        if (userGlobals.userDatabaseTable[i].getUserId() == userId) {
          if (userGlobals.userDatabaseTable[i] != null) {
            this.companyIdentification =
                userGlobals.userDatabaseTable[i].getCompanyId();
            print("Found Users Company ID : " + companyIdentification);
          }
        }
      }

      if (frontEndGlobals.loggedInUserId == userId) {
        this.companyIdentification = frontEndGlobals.loggedInCompanyId;
        print("Found Users Company ID : " + companyIdentification);
      }

      //once the companyId is fetched we can use it to query for all announcements assosiated with that company that the user is listed under
      for (var i = 0; i < globals.announcementDatabaseTable.length; i++) {
        if (globals.announcementDatabaseTable[i].getCompanyId() ==
            this.companyIdentification || frontEndGlobals.loggedInCompanyId == this.companyIdentification) {
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
