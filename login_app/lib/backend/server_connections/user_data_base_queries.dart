import 'dart:math';

import 'package:postgres/postgres.dart';

import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as globals;

class UserDatabaseQueries {
  String userID;
  String adminID;
  String activation_code;

  UserDatabaseQueries() {
    userID = null;
    adminID = null;
    activation_code = null;
  }

  void setUserID(String uID) {
    this.userID = uID;
  }

  void setAdminID(String aID) {
    this.adminID = aID;
  }

  void setActivationCode(String code) {
    this.activation_code = code;
  }

  String getUserID() {
    return userID;
  }

  String getAdminID() {
    return adminID;
  }

  String getActivationCode() {
    return activation_code;
  }

  /////////////////////////////////////////// END OF CONCRETE IMPLEMENTATIONS BEGIN MOCK IMPLEMENTATIONS FOR THE CONCRETE FUNCTIONS////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * This function mocks out the database interaction of creating an announcement, the fuction will be used in tests
 */
  bool registerUserMock(String type, String firstName, String lastName,
      String username, String email, String password, String companyID) {
    int randomInt = new Random().nextInt((9999 - 100) + 1) + 10;

    // conection to DB
    //for mock purposes we will mock out the connection which will either be true of false
    bool connection = true;
    // prepared Statement

    if (connection != false) {
      //set up your prepared statement

      if (type == 'Admin') {
        String adminID = "ADMN-" + randomInt.toString();

        var user = new User(type, firstName, lastName, username, email,
            password, adminID, companyID);

        globals.userDatabaseTable.add(user);

        print("Added a new admin user");

        setUserID(user.getUserId());
        setAdminID(adminID);
        setActivationCode(user.activation_code);

        //execute sql statement
        globals.numUsers++;
        print("Number of users : " + globals.numUsers.toString());
      } else {
        String adminID = " ";

        var user = new User(type, firstName, lastName, username, email,
            password, adminID, companyID);

        globals.userDatabaseTable.add(user);

        print("Added a new user");

        setUserID(user.getUserId());
        setAdminID(adminID);
        setActivationCode(user.activation_code);

        //execute sql statement
        globals.numUsers++;
        print("Number of users : " + globals.numUsers.toString());
      }

      return true;
    } else {
      //This means connection could not be established
      return false;
    }
  }
  
}
