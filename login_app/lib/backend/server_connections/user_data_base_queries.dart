/*
  File name: user_data_base_queries.dart
  Purpose: Allows database interaction for all service contracts for the User subsystem
  Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
import 'dart:math';

import 'package:login_app/subsystems/user_subsystem/company.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';
import 'package:postgres/postgres.dart';

import 'package:login_app/subsystems/announcement_subsystem/announcement.dart';
import 'package:login_app/backend/backend_globals/announcements_globals.dart'
    as announcementGlobals;
import 'package:login_app/backend/backend_globals/user_globals.dart'
    as userGlobals;

/**
 * Class name: UserDatabaseQueries
 * Purpose: This class allows database interaction for all service contracts for the User subsystem 
 * The class has both mock and concrete implementations of the service contracts.
 */
class UserDatabaseQueries {
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
      setAdminId(usr.getUserId());
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
    if (userID != null) {
      print("userID: " + userID);
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
}
