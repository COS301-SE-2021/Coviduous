/*
  * File name: user_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/user_subsystem/company.dart';
import 'package:login_app/subsystems/user_subsystem/user.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================

/**
 * List<Announcement> userDatabaseTable = [] acts like a database table that holds users , this is to mock out functionality for testing
 * numAnnouncements keeps track of number of users in the mock user database table
 */
List<User> userDatabaseTable = [];
int numUsers = 0;

String getUserId(String email) {
  for (int i = 0; i < userDatabaseTable.length; i++) {
    if (userDatabaseTable[i].getEmail() == email) {
      return userDatabaseTable[i].getId();
    }
  }
  return null;
}

String getCompanyId(String id) {
  for (int i = 0; i < userDatabaseTable.length; i++) {
    if (userDatabaseTable[i].getId() == id) {
      return userDatabaseTable[i].getCompanyId();
    }
  }
  return null;
}

/**
 * List<Company> companyDatabaseTable = [] acts like a database table that holds companies , this is to mock out functionality for testing
 * numCompanies keeps track of number of companies in the mock company database table
 */
List<Company> companyDatabaseTable = [];
int numCompanies = 0;
