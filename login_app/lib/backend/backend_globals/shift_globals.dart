/*
  * File name: shift_globals.dart
  
  * Purpose: Global variables used for integration with front and backend.
  
  * Collaborators:
    - Njabulo Skosana
    - Peter Okumbe
    - Chaoane Malakoane
 */
library globals;

import 'package:login_app/subsystems/shift_subsystem/group.dart';
import 'package:login_app/subsystems/shift_subsystem/shift.dart';

//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Shift> shiftDatabaseTable acts like a database table that holds shifts, this is to mock out functionality for testing
 * numShifts keeps track of number of shifts in the mock shift database table
 */
List<Shift> shiftDatabaseTable = [];
int numShifts = 0;

/**
 * List<Group> groupDatabaseTable acts like a database table that holds groups, this is to mock out functionality for testing
 * numGroups keeps track of number of groups in the mock group database table
 */
List<Group> groupDatabaseTable = [];
int numGroups = 0;
