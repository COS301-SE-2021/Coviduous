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
  // PostgreSQLConnection connection;
  // String host = 'localhost';
  // int port = 5432;
  // String dbName = 'mock_CoviduousDB'; // an existing DB name on your localhost
  // String user = 'postgres';
  // String pass = 'TripleHBK2000'; // your postgres user password

  String userId;
  String adminId;
  String activationCode;

  UserDatabaseQueries() {
    userId = null;
    adminId = null;
    activationCode = null;
  }

  void setAdminId(String adminId) {
    this.adminId = adminId;
  }

  void setUserId(String userId) {
    this.userId = userId;
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
  // Future<void> connect() async {
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

  /////////////////////////////////////////// END OF CONCRETE IMPLEMENTATIONS BEGIN MOCK IMPLEMENTATIONS FOR THE CONCRETE FUNCTIONS////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * This function mocks out the database interaction of registering a user, the fuction will be used in tests
 */
  bool registerUserMock(String type, String FirstName, String LastName,
      String Username, String Email, String Password, String companyID) {
    User usr = new User(
        type, FirstName, LastName, Username, Email, Password, companyID);

    if (type == "Admin" || type == "admin" || type == "ADMIN") {
      setAdminId(usr.getAdminId());
      setUserId("");
    } else {
      setUserId(usr.getUserId());
      setAdminId("");
    }
    userGlobals.userDatabaseTable.add(usr);
    userGlobals.numUsers++;
    return true;
  }

  bool registerCompanyMock(String name, String companyAddress, String adminID) {
    Company cmp = new Company(name, companyAddress, adminID);
    userGlobals.companyDatabaseTable.add(cmp);
    return true;
  }

  bool deleteUserAccountMock(String userID) {
    if (userID != "") {
      for (var x = 0; x < userGlobals.userDatabaseTable.length; x++) {
        if (userGlobals.userDatabaseTable[x].getUserId() == userID) {
          print("Removed Successfully");
          userGlobals.userDatabaseTable.removeAt(x);
          userGlobals.numUsers--;
          return true;
        }
      }
    } else
      return false;
  }

  /*bool updateAccountInfoMock(String firstname, String lastname, String email) {}
  statement = connection.prepareStatement("DELETE FROM users WHERE userid=?");
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
}
