library globals;

import 'package:login_app/subsystems/floorplan_subsystem/floor.dart';
//Global variables used throughout the program
//=============================================

//Backend global variables
//==========================
/**
 * List<Floor> globalFloors  acts like a database table that holds floors , this is to mock out functionality for testing
 * globalNumFloors keeps track of number of floors in the mock floors database table
 * Floors refer to the buildings floors, each floor is a level inside the building.
 */
List<Floor> globalFloors = [];
int globalNumFloors = 0;
