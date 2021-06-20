import 'dart:math';

import 'package:login_app/subsystems/user_subsystem/company.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:postgres/postgres.dart';

import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as announcementGlobals;
import 'package:login_app/backend/backend_globals/user_globals.dart'
    as userGlobals;

class UserDatabaseQueries {
  PostgreSQLConnection connection;
  String host = 'localhost';
  int port = 5432;
  String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  String user = 'postgres';
  String pass = 'TripleHBK2000'; // your postgres user password

  String announcementID;
  String timestamp;
  String userId;
  String adminId;
  String activationCode;

  UserDatabaseQueries() {
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

  String getUserID() {
    return userId;
  }

  String getAdminID() {
    return adminId;
  }

  String getActivationCode() {
    return activationCode;
  }

  // create DB connection function to be called in each use case
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

  Future<bool> createAnnouncement(
      String type, String message, String adminID, String companyID) async {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;
    String announcementID = "ANOUNC-" + randomInt.toString();
    String timestamp = DateTime.now().toString();

    await connect(); // connect to db

    // PostgreSQLConnection connection = PostgreSQLConnection(
    //     'localhost', 5432, 'mock_CoviduousDB',
    //     username: 'postgres', password: 'TripleHBK2000');

    // try {
    //   await connection.open();
    //   print("Connected to postgres database...");
    // } catch (e) {
    //   print("error");
    //   print(e.toString());
    // }

    var adminIDQuery = await connection.query(
        "SELECT adminid FROM users WHERE adminid = @id",
        substitutionValues: {'id': adminID});

    var companyIDQuery = await connection.query(
        "SELECT companyid FROM users WHERE adminid = @id",
        substitutionValues: {'id': adminID});

    // check if given adminID && companyID exist in DB
    if (adminIDQuery.length != 0 && companyIDQuery.length != 0) {
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
    }

    return false;
  }

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

/*
  Future<bool> deleteUserAccount(String userID) async {
    if (userID != "") {
      await connect();

      var user = await connection.query(
          "SELECT userid FROM users WHERE userid = @id",
          substitutionValues: {'id': userID});

      if (user != 0) {
        var result = await connection.query(
            "DELETE FROM users WHERE userid = @id",
            substitutionValues: {'id': userID});
        if (result != 0) {
          return true;
        }
      }
    } else {
      return false;
    }
*/
  /*bool deleteUserAccountMock(String userID) {
    if (userID != "") {
      for (int x = 0; x < globals.userDatabaseTable.length; x++) {
        if (globals.userDatabaseTable[x].getUserId() == userID) {
          print("Removed Successfully");
          globals.userDatabaseTable.removeAt(x);
          globals.numUsers--;
          return true;
        }
      }
    } else
      return false;
  }
*/
  bool updateAccountInfoMock(String firstname, String lastname, String email) {}

  /*	statement = connection.prepareStatement("DELETE FROM users WHERE userid=?");
				statement.setString(1, userID);

				int affectedRows=statement.executeUpdate();
			
				if(affectedRows>0)
				{
					return true;
				}
				else 
				{
					return false;
				}
		       }
		       else
		       {
			       throw new Exception("UserID is not given");
		       }
     }

		
  }*/

  // void deleteAnnouncement(String announcementId) async {
  //   var db = Db("mongodb://localhost:27017/test");
  //   await db.open();
  //   DbCollection coll = db.collection('people');
  //   print('Connected to database');
  //   await coll.remove(coll.findOne(where.eq("first_name", announcementId)));
  //   print('Deleted from database');
  //   // return true;
  // }

  Future<bool> viewAdminAnnouncement(String announcementID) async {
    await connect(); // connect to db

    var announcementIDQuery = await connection.query(
        "SELECT announcementid FROM announcements WHERE announcementid = @id",
        substitutionValues: {'id': announcementID});

    // check if given announcementID exist in DB
    if (announcementIDQuery.length != 0) {
      var result = await connection.query(
          "SELECT * FROM announcements WHERE announcementid = @id",
          substitutionValues: {'id': announcementID});

      if (result != null) {
        return true;
      }
    }

    return false;
  }

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
      announcementGlobals.announcementDatabaseTable.add(announcement1);
      print("Added a new announcement");
      //execute sql statement
      announcementGlobals.numAnnouncements++;
      print("Number of announcements : " +
          announcementGlobals.numAnnouncements.toString());
      return true;
    } else {
      //This means connection could not be established
      return false;
    }
  }

  bool registerUserMock(String type, String FirstName, String LastName,
      String Username, String Email, String Password, String companyID) {
    User usr = new User(
        type, FirstName, LastName, Username, Email, Password, companyID);

    userGlobals.userDatabaseTable.add(usr);
    userGlobals.numUsers++;
    return true;
  }

  bool registerCompanyMock(String name, String companyAddress, String adminID) {
    Company cmp = new Company(name, companyAddress, adminID);
    userGlobals.companyDatabaseTable.add(cmp);
    return true;
  }
}
